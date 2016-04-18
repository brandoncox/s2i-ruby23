# s2i-ruby23
A source to image builder image based on Ruby 2.3.0


## To Test Run 
	make
	s2i build test/rack-test-app/ ruby2.3 s2idemoimage
	docker run -p 8080:8080 s2idemoimage
	
Then browse to http://localhost:8080 and you should see "Hello World" show in the browser.
