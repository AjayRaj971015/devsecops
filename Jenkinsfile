pipeline{
	agent any
	tools{
		maven 'Maven'
	     }
	stages{
		stage ('Initialize') {
		steps {
			sh '''
				echo "PATH = ${PATH}"
				echo "M2_HOME = ${M2_HOME}"
			    '''
		      }
 		}
		stage('Install Dependencies') {
            	steps {
                	sh 'cd $WORKSPACE'
 	               git branch: "master",
                    	url: "https://github.com/AjayRaj971015/devsecops"
                	sh 'ls'
            }
        }
		stage ('check-git-secrets') {
		steps {
			sh'cd $WORKSPACE'
			sh'rm trufflhog || true'
			sh'docker pull gesellix/trufflehog'
			sh'docker run -t gesellix/trufflehog --json https://github.com/AjayRaj971015/devsecops.git > trufflehog.txt'	
			sh 'cat trufflehog.txt'
			
 		      }

				             }
		
		stage ('Dependency Check') {
		steps {
			sh'cd $WORKSPACE'
			sh 'rm owasp* || true'
			sh 'wget "https://raw.githubusercontent.com/AjayRaj971015/devsecops/master/dc.sh"'
			sh 'chmod +x dc.sh'
			sh './dc.sh || true'
			}
 			}
		stage('SAST') {
		steps {
		withSonarQubeEnv('sonar') {
			//Static Application Security Testing (SAST)
			sh'cd $WORKSPACE'
			sh 'docker start sonarqube'
			sh 'mvn sonar:sonar -Dsonar.host.url=http://192.168.80.100:9000 -Dsonar.login=sqa_5f39772be0b45586ef2e8d140d16c577788ebdaa'
			//sh 'mvn sonar:sonar || true'
			sh 'cat target/sonar/report-task.txt'
			
		}

	}
	}

		stage ('build') {
			steps {
				//sh'cd $WORKSPACE'
			 	sh 'mvn clean package'
                		
			      }
			        }
		stage ('deploy-to-tomcat') {
		  steps {
		  //sshagent(['192.168.80.101'])
			sh'cd $WORKSPACE'
			sh'sshpass -p "ajay123" ssh root@192.168.80.101 "./tomcat.sh "'	
			sh'sshpass -p "ajay123" scp -o StrictHostkeyChecking=no target/WebApp.war root@192.168.80.101:/opt/tomcat/apache-tomcat-9.0.64/webapps/webapp.war'		
			}
		}
		stage('DAST') {
		 steps {
			 //Dynamic Application Security Testing (DAST)
			//sh'cd $WORKSPACE'
	 		sshagent(['zap']) {
			sh 'sshpass -p "ajay123" ssh -o UserKnownHostsFile=/dev/null -o StrictHostkeyChecking=no shuhari@192.168.80.103 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://192.168.80.101:8080/webapp/" || true'
			//sh 'sshpass -p "ajay123" ssh -o UserKnownHostsFile=/dev/null -o StrictHostkeyChecking=no shuhari@192.168.80.103 "docker run --rm -v $(pwd):/zap/wrk -u $(id -u ${USER}):$(id -g ${USER}) -t owasp/zap2docker-stable zap-baseline.py -t http://192.168.80.101:8080/webapp/ -g gen.conf -r basescan.html" || true '
			}
			}

}
		
             }
	}
