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
		stage ('check-git-secrets') {
		steps {
			//sh'cd $WORKSPACE'
			sh'rm trufflhog || true'
			sh'docker pull gesellix/trufflehog'
			sh'docker run -t gesellix/trufflehog --json https://github.com/AjayRaj971015/devsecops.git > trufflehog.txt'	
			sh 'cat trufflehog.txt'
			archiveArtifacts artifacts: 'trufflehog.txt', onlyIfSuccessful: true
                        emailext attachLog: true, attachmentsPattern: 'trufflehog*', 
                        body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}\n Thankyou,\n IACSD-Project Group-1", 
                        subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME} - success", mimeType: 'text/html', to: "maskoff.ajayraj@gmail.com"
 		      }

				             }
		
		stage ('Dependency Check') {
		steps {
			//sh'cd $WORKSPACE'
			sh 'rm owasp* || true'
			sh 'wget "https://raw.githubusercontent.com/AjayRaj971015/devsecops/master/dc.sh"'
			sh 'chmod +x dc.sh'
			sh './dc.sh || true '
	
			}
 			}
		stage('SAST') {
		steps {
		withSonarQubeEnv('sonar') {
			//sh'cd $WORKSPACE'
			sh 'docker start sonarqube'
			//sh 'mvn clean install  sonar:sonar -Dsonar.host.url=http://192.168.80.100:900 -Dsonar.login=sqa_5f39772be0b45586ef2e8d140d16c577788ebdaa -Dsonar.projectName=iacsd_projevt1'
			//sh 'mvn verify sonar:sonar -Dsonar.login=admin -Dsonar.password=admin1'
			sh 'mvn sonar:sonar -Dsonar.host.url=http://192.168.80.100:9000 -Dsonar.login=sqa_5f39772be0b45586ef2e8d140d16c577788ebdaa'
			//sh 'mvn sonar:sonar || true'
			//sh 'mvn sonar:sonar -Dsonar.projectKey=group1 -Dsonar.host.url=http://192.168.80.100:9000 -Dsonar.login=sqa_76829e1cdc1af5936e79ac3d0cb50d5f4f13c5c8 || true'
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
			//sh'sshpass -p "ajay123" scp -o StrictHostkeyChecking=no target/WebApp.war root@192.168.80.101 "rm /opt/tomcat/apache-tomcat-9.0.64/webapps/webapp.war"'
			sh'sshpass -p "ajay123" scp -o StrictHostkeyChecking=no target/WebApp.war root@192.168.80.101:/opt/tomcat/apache-tomcat-9.0.64/webapps/webapp.war'
			//sh'scp -o StrictHostkeyChecking=no /var/lib/jenkins/workspace/DSO/target/WebApp.war root@192.168.80.101:/opt/tomcat/apache-tomcat-9.0.64/webapps/webapp.war'  
			}
		}
		stage('DAST') {
		 steps {
			//sh'cd $WORKSPACE'
	 		sshagent(['zap']) {
	   		sh 'sshpass -p "ajay123" ssh -o UserKnownHostsFile=/dev/null -o StrictHostkeyChecking=no shuhari@192.168.80.103 "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://192.168.80.101:8080/webapp/" || true'
			}
			}

}
		
             }
	}
