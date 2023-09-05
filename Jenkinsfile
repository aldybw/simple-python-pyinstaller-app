// pipeline {
//     agent none

//     options {
//         skipStagesAfterUnstable()
//     }

//     stages {
//         stage('Build') {
//             agent {
//                 docker {
//                     image 'python:2-alpine'
//                 }
//             }

//             steps {
//                 sh 'python -m py_compile sources/add2vals.py sources/calc.py'
//                 stash(name: 'compiled-results', includes: 'sources/*.py*')
//             }
//         }

//         stage('Test') {
//             agent {
//                 docker {
//                     image 'qnib/pytest'
//                 }
//             }

//             steps {
//                 sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
//             }

//             post {
//                 always {
//                     junit 'test-reports/results.xml'
//                 }
//             }
//         }

//         stage('Deliver') { 
//             agent any
//             environment { 
//                 VOLUME = '$(pwd)/sources:/src'
//                 IMAGE = 'cdrx/pyinstaller-linux:python2'
//             }

//             steps {
//                 dir(path: env.BUILD_ID) { 
//                     unstash(name: 'compiled-results') 
//                     sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
//                 }
//             }

//             post {
//                 success {
//                     archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
//                     sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
//                 }
//             }
//         }
//     }
// }


// node {
//     stage('Build') {
//         docker.image('python:2-alpine').inside {
//             checkout scm
//             sh 'python -m py_compile sources/add2vals.py sources/calc.py'
//         }
//     }

//     stage('Test') {
//         try {
//             docker.image('qnib/pytest').inside {
//                 checkout scm
//                 sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
//             }
//         } finally {
//             junit 'test-reports/results.xml'
//         }
//     }

//     stage('Deliver') {
//         try {
//             docker.image('cdrx/pyinstaller-linux:python2').inside {
//                 checkout scm
//                 sh 'pyinstaller --onefile sources/add2vals.py'
//             }
//         } finally {
//             archiveArtifacts 'dist/add2vals'
//         }
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