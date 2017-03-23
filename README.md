# Perfect Server Side Swift File Uploads example

Fork or check out, then `swift package generate-xcodeproj` in terminal,
open Xcode build & run.

How to test:
upload in terminal:
`cd webroot`
`curl -i -X POST -H "Content-Type: multipart/form-data" -F "data=@languages.png" http://localhost:8080/upload`

display on broswer:
`http://localhost:8080/image`

