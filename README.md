## demo-gateway - Simple API Gateway with Zuul

  **Startup**
  
1.  Start the config-server and eureka-server.
  - `cd common/config-server`
  - `mvn spring-boot:run`
  - `cd common/eureka`
  - `mvn spring-boot:run`

2.  Start 5 separate copies of the word-server, using the profiles "subject", "verb", "article", "adjective", and "noun".  There are several ways to do this, depending on your preference:
  - If you wish to use Maven, open separate command prompts in the target directory and run these commands:
    - mvn spring-boot:run -Drun.jvmArguments="-Dspring.profiles.active=subject"
    - mvn spring-boot:run -Drun.jvmArguments="-Dspring.profiles.active=verb"
    - mvn spring-boot:run -Drun.jvmArguments="-Dspring.profiles.active=article"
    - mvn spring-boot:run -Drun.jvmArguments="-Dspring.profiles.active=adjective"
    - mvn spring-boot:run -Drun.jvmArguments="-Dspring.profiles.active=noun"
  - Or if you wish to run from directly within STS, right click on the project, Run As... / Run Configurations... .  From the Spring Boot tab specify a Profile of "subject", UNCHECK live bean support, and Run.  Repeat this process (or copy the run configuration) for the profiles "verb", "article", "adjective", "noun".

3.  Check Eureka at [http://localhost:8010](http://localhost:8010).   Any warnings about running a single instance are expected.  Ensure that each of your 5 applications are eventually listed in the "Application" section, bearing in mind it may take a few moments for the registration process to be 100% complete.	

4.  Optional - If you wish, you can click on the link to the right of any of these servers.  Replace the "/info" with "/" and refresh several times.  You can observe the randomly generated words.
  
5. Start the gateway
  - `cd gateway`
  - `mvn spring-boot:run`

6. Check Eureka at [http://localhost:8010](http://localhost:8010).  The GATEWAY should now be listed as one the services.  If you wish, you can click on the link to the right of the GATEWAY server.  Replace the "/info" with "/" and refresh several times.  You can observe the randomly generated sentence.  This can also be invoked at [http://localhost:8080/](http://localhost:8080/).

  **Sample Output:**
  
*Dynamically Generated Sentence*

Bryan transport an reasonable man

**Reflection**

1.  How does the application know where the individual word services are?  
*Zuul automatically uses Eureka service discovery.*
2.  How did this application know how to contact Eureka?  
*We used Spring Cloud Config, and the server / repository we are using knows the location.*
3.  Why do we get 304s randomly on the AJAX requests?  
*Since the word values are randomly generated, 304s only occur in the unlikely event that the server returns an identical value to what it returned in the previous request.*  
4.  ETags are a great way to optimize web / REST applications, but the ETag usage demonstrated here is impractical for two reasons.  
*1) the values we are receiving are intended to be random, 304s only occur because our set of seed values is relatively small, and 2) the ETag itself is far larger than any of our words, so we actually consume more bandwidth than we save!*
5.  This web site uses Thymeleaf, JQuery, and Bootstrap, though the usage of each is very rudimentary.  The `application.properties` file has a setting that allows the Thymeleaf template changes to be loaded immediately, which is useful in development.

I was able to get the config-server to run on Cloud Foundry by changing the POM.XML with '<java.version>1.7</java.version>' and packaging as a '<packaging>war</packaging>' instead of a 'jar'.  
