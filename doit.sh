# This is copied from my notes taken when testing
# Follow the install steps at the main site
# https://docs.getindico.io/en/stable/installation/development/


psql -p 5432 -U postgres -h localhost -c "ALTER USER postgres WITH CREATEDB;"
createdb indico_template -O postgres -p 5432 -U postgres -h localhost
psql -p 5432 -U postgres -h localhost -d indico_template -c "CREATE EXTENSION unaccent; CREATE EXTENSION pg_trgm;"
createdb indico -T indico_template -O postgres -p 5432 -U postgres -h localhost

python -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
pip install -e '.[dev]'
indico setup wizard --dev
brew install weasyprint
export DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib:$DYLD_FALLBACK_LIBRARY_PATH
indico db prepare
indico i18n compile indico

brew install gobject-introspection
sudo ln -s /opt/homebrew/opt/glib/lib/libgobject-2.0.0.dylib /usr/local/lib/gobject-2.0
sudo ln -s /opt/homebrew/opt/pango/lib/libpango-1.0.dylib /usr/local/lib/pango-1.0
sudo ln -s /opt/homebrew/opt/harfbuzz/lib/libharfbuzz.dylib /usr/local/lib/harfbuzz
sudo ln -s /opt/homebrew/opt/fontconfig/lib/libfontconfig.1.dylib /usr/local/lib/fontconfig-1
sudo ln -s /opt/homebrew/opt/pango/lib/libpangoft2-1.0.dylib /usr/local/lib/pangoft2-1.0

./bin/maintenance/build-assets.py indico --dev

indico run -h localhost -q --enable-evalex
