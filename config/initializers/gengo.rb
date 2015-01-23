require 'gengo'

$gengo = Gengo::API.new({
    :public_key => ENV['GENGO_PUBLIC_KEY']||'hmuw~$mavmNb)j2kdGr-Zw@0](CHTx7AKssqsM={a]d=k$WZi0lIJ1mdjnmdI9IN',
    :private_key => ENV['GENGO_PRIVATE_KEY']||'5W-KAdRg(~UjQ0h6_6fdR[]yK8FpB-}VSi2az5am$WyYMsB75CGV~zhFaIbBRJ|i',
    :sandbox => ENV['GENGO_PRODUCTION'] == "true" ? false : true,
    :api_version => '2'
})
