
Lit.authentication_function = :authenticate_user!
Lit.key_value_engine = ENV['LIT_STORAGE'] || 'activesupport'
Lit.fallback = true
Lit.humanize_key = true
Lit.api_enabled = true
Lit.api_key = 'ala'
Lit.all_translations_are_html_safe = true
Lit.init
