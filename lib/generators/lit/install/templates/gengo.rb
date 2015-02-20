require 'gengo'
$gengo = Gengo::API.new({
  :public_key => ENV['GENGO_PUBLIC_KEY'],
  :private_key => ENV['GENGO_PRIVATE_KEY'],
  :sandbox => ENV['GENGO_PRODUCTION'] == "true" ? false : true,
  :api_version => '2'
})