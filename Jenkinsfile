// node {
//     stage('Build') {
//         docker.image('python:2-alpine').inside {
//             checkout scm
//             sh 'python -m py_compile sources/add2vals.py sources/calc.py'
//         }
//     }

//     try {
//         stage('Test') {
//             docker.image('qnib/pytest').inside {
//                 checkout scm
//                 sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
//             }
//         }
//     } catch (e) {
//         echo 'This will run only if failed'

//         // Since we're catching the exception in order to report on it,
//         // we need to re-throw it, to ensure that the build is marked as failed
//         throw e
//     } finally {
//         def currentResult = currentBuild.result ?: 'ALWAYS'
//         if (currentResult == 'ALWAYS') {
//             junit 'test-reports/results.xml'
//         }

//         def previousResult = currentBuild.previousBuild?.result
//         if (previousResult != null && previousResult != currentResult) {
//             echo 'This will run only if the state of the Pipeline has changed'
//             echo 'For example, if the Pipeline was previously failing but is now successful'
//         }

//         echo 'This will always run'
//     }

//     try {
//         stage('Deliver') {
//             docker.image('cdrx/pyinstaller-linux:python2').inside {
//                 checkout scm
//                 sh 'pyinstaller --onefile sources/add2vals.py'
//             }
//         }
//     } catch (e) {
//         echo 'This will run only if failed'

//         // Since we're catching the exception in order to report on it,
//         // we need to re-throw it, to ensure that the build is marked as failed
//         throw e
//     } finally {
//         def currentResult = currentBuild.result ?: 'SUCCESS'
//         if (currentResult == 'SUCCESS') {
//             archiveArtifacts 'dist/add2vals/*'
//         }

//         def previousResult = currentBuild.previousBuild?.result
//         if (previousResult != null && previousResult != currentResult) {
//             echo 'This will run only if the state of the Pipeline has changed'
//             echo 'For example, if the Pipeline was previously failing but is now successful'
//         }

//         echo 'This will always run'
//     }
// }
pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }
            steps {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Deliver') {
            agent {
                docker {
                    image 'cdrx/pyinstaller-linux:python2'
                }
            }
            steps {
                sh 'pyinstaller --onefile sources/add2vals.py'
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals'
                }
            }
        }
    }
}
