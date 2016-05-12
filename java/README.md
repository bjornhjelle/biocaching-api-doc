First: 

keytool -import -alias biocaching -keystore cacerts -file ssl_public_cert/cert.pem 


To build and run from the command line: 

$ ./gradlew build
$ ./gradlew run -Dexec.args="https://api.biocaching.com bjorn@biocaching.com test1234"

To build and run from intellij: 

    * use "File, Open", and then select the build.gradle fil 