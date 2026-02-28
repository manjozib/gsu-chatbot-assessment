-- Optional: for accent-insensitive search in the future
-- CREATE EXTENSION IF NOT EXISTS unaccent;

ALTER TABLE knowledge_base
    ADD COLUMN IF NOT EXISTS fts tsvector;

-- Backfill FTS for existing rows with field weights:
-- A: category, B: question, C: answer, D: keywords
UPDATE knowledge_base
SET fts =
            setweight(to_tsvector('english', coalesce(category, '')), 'A') ||
            setweight(to_tsvector('english', coalesce(question, '')), 'B') ||
            setweight(to_tsvector('english', coalesce(answer,   '')), 'C') ||
            setweight(to_tsvector('english', coalesce(keywords, '')), 'D');

-- Keep fts updated on insert/update
CREATE OR REPLACE FUNCTION kb_fts_update() RETURNS trigger AS $$
BEGIN
  NEW.fts :=
    setweight(to_tsvector('english', coalesce(NEW.category, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(NEW.question, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(NEW.answer,   '')), 'C') ||
    setweight(to_tsvector('english', coalesce(NEW.keywords, '')), 'D');
RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS kb_fts_update ON knowledge_base;
CREATE TRIGGER kb_fts_update
    BEFORE INSERT OR UPDATE ON knowledge_base
                         FOR EACH ROW EXECUTE FUNCTION kb_fts_update();

-- Fast index for FTS
DROP INDEX IF EXISTS idx_kb_fts;
CREATE INDEX idx_kb_fts ON knowledge_base USING GIN (fts);