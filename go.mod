module github.com/paulosimao-ardanlabs/go-module-replace-main

go 1.18

// require github.com/paulosimao-ardanlabs/go-module-replace-a v0.0.0-00010101000000-000000000000

replace github.com/paulosimao-ardanlabs/go-module-replace-a => github.com/paulosimao-ardanlabs/go-module-replace-b v0.0.0-20220721083559-e84c266793ea

require github.com/paulosimao-ardanlabs/go-module-replace-a v0.0.0-00010101000000-000000000000
