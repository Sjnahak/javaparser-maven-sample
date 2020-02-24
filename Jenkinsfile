pipeline {
    agent any
    tools { 
        maven 'maven' 
        jdk 'jdk' 
    }
    stages {
        stage('SCM Checkout'){
            steps {
                git url: 'https://github.com/Sjnahak/javaparser-maven-sample.git', credentialsId: 'credgit', branch: 'master'
            }
        }
        
        stage ('Clean worksapce') {
            steps {
                sh 'mvn clean'
                echo 'cleaning workspace'
                }
            }
        
		stage('Sonarqube') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
           }
           steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        
        stage ('Build') {
            steps {
                sh 'mvn clean package -DskipTests=true -Dbuild.number=${BUILD_NUMBER}'
                echo 'Building jar file'
            }
        }
        
        
	stage("publish to nexus") {
            steps {
                sh 'mvn deploy'
            }
        }

        /*stage ('Deploy to embedded tomcat via bash'){
            steps {
                sh '/var/lib/jenkins/scripts/maven.sh'       
                }
        
    }*/
}

}
