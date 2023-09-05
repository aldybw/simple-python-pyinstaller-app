pipeline {
    agent none

    options {
        skipStagesAfterUnstable()
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }

            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
                stash(name: 'compiled-results', includes: 'sources/*.py*')
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }

            steps {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }

            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }

        stage('Deliver') { 
            agent any
            environment { 
                VOLUME = '$(pwd)/sources:/src'
                IMAGE = 'cdrx/pyinstaller-linux:python2'
            }

            steps {
                dir(path: env.BUILD_ID) { 
                    // echo $VOLUME
                    unstash(name: 'compiled-results') 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
                }
            }

            post {
                success {
                    archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                }
            }
        }
    }
}


node {
    stage('Build') {
        docker.image('python:2-alpine').inside {
            checkout scm
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
    }

    stage('Test') {
        try {
            docker.image('qnib/pytest').inside {
                sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
            }
        } finally {
            junit 'test-reports/results.xml'
        }
    }

    withEnv(["VOLUME=${pwd}/sources:/src", 'IMAGE=cdrx/pyinstaller-linux:python2']) {
        stage('Deliver') {
            dir(path: env.BUILD_ID) {
                try {
                    docker.image('cdrx/pyinstaller-linux:python2').inside {
                        echo $VOLUME
                        unstash(name: 'compiled-results') 
                        sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
                    }
                } finally {
                    archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
                }
            } 
        }
    }

    // if (currentBuild.currentResult == 'SUCCESS') { 
    //     withEnv(["VOLUME=${pwd}/sources:/src", 'IMAGE=cdrx/pyinstaller-linux:python2']) {
    //         stage('Deliver') {
    //             dir(path: env.BUILD_ID) {
    //                 try {
    //                     docker.image('cdrx/pyinstaller-linux:python2').inside {
    //                         echo $VOLUME
    //                         unstash(name: 'compiled-results') 
    //                         sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
    //                     }
    //                 } finally {
    //                     archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
    //                     sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
    //                 }
    //             } 
    //         }
    //     }
    // }
}
