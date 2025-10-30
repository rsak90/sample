-- Enhanced EditCheck Code Editor Database Migration
-- Migration Script: EnhancedCodeEditor_Migration.sql
-- Target Database: PostgreSQL

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create UserProfiles table for storing user preferences
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL,
    preferences JSONB NULL, -- JSON object of user preferences
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_user_profiles_user_id UNIQUE (user_id)
);

-- Create index for faster user lookups
CREATE INDEX idx_user_profiles_user_id ON user_profiles (user_id);

-- Create CodeValidationCache table for caching validation results
CREATE TABLE code_validation_cache (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code_hash VARCHAR(64) NOT NULL, -- SHA256 hash of the code
    language VARCHAR(50) NOT NULL,
    validation_result JSONB NOT NULL, -- JSON object of validation result
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    
    CONSTRAINT uk_code_validation_cache_hash_language UNIQUE (code_hash, language)
);

-- Create indexes for cache lookups
CREATE INDEX idx_code_validation_cache_hash_language ON code_validation_cache (code_hash, language);
CREATE INDEX idx_code_validation_cache_expires_at ON code_validation_cache (expires_at);

-- Add new columns to custom_functions table for enhanced editor features
ALTER TABLE custom_functions ADD COLUMN 
    editor_theme VARCHAR(50) NULL DEFAULT 'vs-dark';
ALTER TABLE custom_functions ADD COLUMN 
    last_validation_result JSONB NULL; -- JSON object of last validation
ALTER TABLE custom_functions ADD COLUMN 
    formatting_preferences JSONB NULL; -- JSON object of formatting preferences

-- Create FieldReferences table for tracking field usage in rules
CREATE TABLE field_references (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    edit_check_id UUID NOT NULL,
    field_name VARCHAR(255) NOT NULL,
    field_type VARCHAR(100) NULL,
    usage_type VARCHAR(50) NOT NULL, -- 'condition', 'assignment', 'comparison'
    line_number INTEGER NOT NULL,
    column_number INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_field_references_edit_check 
        FOREIGN KEY (edit_check_id) REFERENCES edit_checks(id) ON DELETE CASCADE
);

-- Create indexes for field reference lookups
CREATE INDEX idx_field_references_edit_check_id ON field_references (edit_check_id);
CREATE INDEX idx_field_references_field_name ON field_references (field_name);

-- Create StudyPinStates table for tracking pinned studies per user
CREATE TABLE study_pin_states (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL,
    study_id UUID NOT NULL,
    is_pinned BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_study_pin_states_study 
        FOREIGN KEY (study_id) REFERENCES studies(id) ON DELETE CASCADE,
    CONSTRAINT uk_study_pin_states_user_study UNIQUE (user_id, study_id)
);

-- Create indexes for study pin state lookups
CREATE INDEX idx_study_pin_states_user_id ON study_pin_states (user_id);
CREATE INDEX idx_study_pin_states_study_id ON study_pin_states (study_id);
CREATE INDEX idx_study_pin_states_is_pinned ON study_pin_states (is_pinned);

-- Create EditorSessions table for tracking active editing sessions
CREATE TABLE editor_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(255) NOT NULL,
    edit_check_id UUID NOT NULL,
    session_data JSONB NULL, -- JSON object of session state
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT true,
    
    CONSTRAINT fk_editor_sessions_edit_check 
        FOREIGN KEY (edit_check_id) REFERENCES edit_checks(id) ON DELETE CASCADE
);

-- Create indexes for session management
CREATE INDEX idx_editor_sessions_user_id ON editor_sessions (user_id);
CREATE INDEX idx_editor_sessions_edit_check_id ON editor_sessions (edit_check_id);
CREATE INDEX idx_editor_sessions_last_activity ON editor_sessions (last_activity);

-- Insert default user preferences for existing users (if any user system exists)
-- This would need to be adapted based on your actual user management system
INSERT INTO user_profiles (user_id, preferences)
SELECT DISTINCT created_by, 
    '{"editorTheme":"vs-dark","fontSize":14,"tabSize":4,"wordWrap":true,"minimap":true,"lineNumbers":true,"pinnedElements":{},"pinnedStudies":{},"formatOnSave":true,"lintingEnabled":true}'::jsonb
FROM custom_functions 
WHERE created_by IS NOT NULL 
    AND created_by != '' 
    AND created_by NOT IN (SELECT user_id FROM user_profiles);

-- Create trigger function to automatically update updated_at timestamp for StudyPinStates
CREATE OR REPLACE FUNCTION update_study_pin_states_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for StudyPinStates
CREATE TRIGGER tr_study_pin_states_updated_at
    BEFORE UPDATE ON study_pin_states
    FOR EACH ROW
    EXECUTE FUNCTION update_study_pin_states_updated_at();

-- Create trigger function to automatically update updated_at timestamp for UserProfiles
CREATE OR REPLACE FUNCTION update_user_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for UserProfiles
CREATE TRIGGER tr_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_user_profiles_updated_at();

-- Create function for cleaning up expired cache entries
CREATE OR REPLACE FUNCTION cleanup_expired_validation_cache()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM code_validation_cache 
    WHERE expires_at < CURRENT_TIMESTAMP;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Create function for managing editor sessions
CREATE OR REPLACE FUNCTION cleanup_inactive_editor_sessions(inactive_threshold_hours INTEGER DEFAULT 24)
RETURNS INTEGER AS $$
DECLARE
    updated_count INTEGER;
BEGIN
    UPDATE editor_sessions 
    SET is_active = false
    WHERE last_activity < (CURRENT_TIMESTAMP - INTERVAL '1 hour' * inactive_threshold_hours)
    AND is_active = true;
    
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    RETURN updated_count;
END;
$$ LANGUAGE plpgsql;

-- Create function for getting user pinned studies
CREATE OR REPLACE FUNCTION get_user_pinned_studies(p_user_id VARCHAR(255))
RETURNS TABLE (
    study_id UUID,
    study_name VARCHAR(255),
    is_pinned BOOLEAN,
    updated_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT s.id, s.name, sps.is_pinned, sps.updated_at
    FROM studies s
    INNER JOIN study_pin_states sps ON s.id = sps.study_id
    WHERE sps.user_id = p_user_id AND sps.is_pinned = true
    ORDER BY sps.updated_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Create function for updating study pin state (upsert)
CREATE OR REPLACE FUNCTION update_study_pin_state(
    p_user_id VARCHAR(255),
    p_study_id UUID,
    p_is_pinned BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO study_pin_states (user_id, study_id, is_pinned, created_at, updated_at)
    VALUES (p_user_id, p_study_id, p_is_pinned, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    ON CONFLICT (user_id, study_id)
    DO UPDATE SET 
        is_pinned = EXCLUDED.is_pinned,
        updated_at = CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Create function for getting user preferences with defaults
CREATE OR REPLACE FUNCTION get_user_preferences(p_user_id VARCHAR(255))
RETURNS JSONB AS $$
DECLARE
    user_prefs JSONB;
    default_prefs JSONB := '{"editorTheme":"vs-dark","fontSize":14,"tabSize":4,"wordWrap":true,"minimap":true,"lineNumbers":true,"pinnedElements":{},"pinnedStudies":{},"formatOnSave":true,"lintingEnabled":true}';
BEGIN
    SELECT preferences INTO user_prefs
    FROM user_profiles
    WHERE user_id = p_user_id;
    
    IF user_prefs IS NULL THEN
        -- Insert default preferences for new user
        INSERT INTO user_profiles (user_id, preferences)
        VALUES (p_user_id, default_prefs)
        ON CONFLICT (user_id) DO NOTHING;
        
        RETURN default_prefs;
    END IF;
    
    RETURN user_prefs;
END;
$$ LANGUAGE plpgsql;

-- Create function for updating user preferences
CREATE OR REPLACE FUNCTION update_user_preference(
    p_user_id VARCHAR(255),
    p_preference_key VARCHAR(255),
    p_preference_value JSONB
)
RETURNS VOID AS $$
DECLARE
    current_prefs JSONB;
BEGIN
    -- Get current preferences or create default
    SELECT get_user_preferences(p_user_id) INTO current_prefs;
    
    -- Update the specific preference
    current_prefs := jsonb_set(current_prefs, ARRAY[p_preference_key], p_preference_value);
    
    -- Save back to database
    INSERT INTO user_profiles (user_id, preferences, created_at, updated_at)
    VALUES (p_user_id, current_prefs, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    ON CONFLICT (user_id)
    DO UPDATE SET 
        preferences = EXCLUDED.preferences,
        updated_at = CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions to the database user
GRANT ALL PRIVILEGES ON TABLE user_profiles TO postgresuser;
GRANT ALL PRIVILEGES ON TABLE code_validation_cache TO postgresuser;
GRANT ALL PRIVILEGES ON TABLE field_references TO postgresuser;
GRANT ALL PRIVILEGES ON TABLE study_pin_states TO postgresuser;
GRANT ALL PRIVILEGES ON TABLE editor_sessions TO postgresuser;

-- Grant execute permissions on functions
GRANT EXECUTE ON FUNCTION cleanup_expired_validation_cache() TO postgresuser;
GRANT EXECUTE ON FUNCTION cleanup_inactive_editor_sessions(INTEGER) TO postgresuser;
GRANT EXECUTE ON FUNCTION get_user_pinned_studies(VARCHAR(255)) TO postgresuser;
GRANT EXECUTE ON FUNCTION update_study_pin_state(VARCHAR(255), UUID, BOOLEAN) TO postgresuser;
GRANT EXECUTE ON FUNCTION get_user_preferences(VARCHAR(255)) TO postgresuser;
GRANT EXECUTE ON FUNCTION update_user_preference(VARCHAR(255), VARCHAR(255), JSONB) TO postgresuser;

-- Success message
SELECT 'Enhanced EditCheck Code Editor database migration completed successfully!' as status;