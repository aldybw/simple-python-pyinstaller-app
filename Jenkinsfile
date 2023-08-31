node {
    properties(
        [
            skipStagesAfterUnstable()
        ]
    )

    stage('Build') {
        docker.image('python:2-alpine').inside {
            // checkout scm
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
    }

    try {
        stage('Test') {
            docker.image('qnib/pytest').inside {
                checkout scm
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
        }
    } catch (e) {
        // echo 'This will run only if failed'

        // Since we're catching the exception in order to report on it,
        // we need to re-throw it, to ensure that the build is marked as failed
        throw e
    } finally {
        def currentResult = currentBuild.result ?: 'ALWAYS'
        if (currentResult == 'ALWAYS') {
            junit 'test-reports/results.xml'
        }
        // if (currentResult == 'SUCCESS') {
        //     archiveArtifacts 'dist/add2vals'
        // }

        // def previousResult = currentBuild.previousBuild?.result
        // if (previousResult != null && previousResult != currentResult) {
        //     echo 'This will run only if the state of the Pipeline has changed'
        //     echo 'For example, if the Pipeline was previously failing but is now successful'
        // }

        // echo 'This will always run'
    }

    try {
        withEnv(["VOLUME=${pwd}/sources:/src", "IMAGE=cdrx/pyinstaller-linux:python2"]) {
            stage('Deliver') {
                dir(path: env.BUILD_ID) { 
                    unstash(name: 'compiled-results') 
                    // checkout scm
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
                }
                // docker.image('cdrx/pyinstaller-linux:python2').inside {
                //     checkout scm
                //     sh 'pyinstaller --onefile sources/add2vals.py'
                // }
            }
        }

            // stage('Deliver') {
            //     docker.image('cdrx/pyinstaller-linux:python2').inside {
            //         checkout scm
            //         sh 'pyinstaller --onefile sources/add2vals.py'
            //     }
            // }
    } catch (e) {
        // echo 'This will run only if failed'

        // Since we're catching the exception in order to report on it,
        // we need to re-throw it, to ensure that the build is marked as failed
        throw e
    } finally {
        def currentResult = currentBuild.result ?: 'SUCCESS'
        if (currentResult == 'SUCCESS') {
            archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals" 
            sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
        }

        // def previousResult = currentBuild.previousBuild?.result
        // if (previousResult != null && previousResult != currentResult) {
        //     echo 'This will run only if the state of the Pipeline has changed'
        //     echo 'For example, if the Pipeline was previously failing but is now successful'
        // }

        // echo 'This will always run'
    }
}

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

