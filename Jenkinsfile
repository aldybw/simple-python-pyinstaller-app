// pipeline {
//     agent none
//     environment {
//         PUBLIC_URL       = 'https://aldybw.github.io/simple-python-pyinstaller-app'
//         GITHUB_TOKEN     = credentials('jenkins-github-token')
//         GITHUB_REPOSITORY = 'aldybw/simple-python-pyinstaller-app'
//     }
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
//                     // echo $VOLUME
//                     unstash(name: 'compiled-results') 
//                     sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'" 
//                     sh 'chmod +x ../jenkins/scripts/github-pages.sh && ../jenkins/scripts/github-pages.sh'
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


node {
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
    }
    
    stage('Test') {
        stage('Test') {
            try {
                docker.image('qnib/pytest').inside {
                    sh 'py.test --junit-xml test-reports/results.xml sources/test_calc.py'
                }
            } catch (e) {
                echo 'Failed'
                throw e
            } finally {
                junit 'test-reports/results.xml'
            }
        }
    }
    
    // stage('Manual Approval') {
    //     input message: 'Lanjutkan ke tahap Deploy?'
    // }
    
    stage('Deliver') {
        dir("${env.BUILD_ID}") {
            input message: 'Lanjutkan ke tahap Deploy? (Klik "Proceed" untuk melanjutkan eksekusi pipeline ke tahap Deploy atau "Abort" untuk menghentikan eksekusi pipeline)' 
            unstash(name: 'compiled-results')
            sh "docker run --rm -v ${env.WORKSPACE}/${env.BUILD_ID}/sources:/src cdrx/pyinstaller-linux:python2 'pyinstaller -F add2vals.py'"
        }
        sleep time: 1, unit: 'MINUTES'
        archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
        sh "docker run --rm -v ${env.WORKSPACE}/${env.BUILD_ID}/sources:/src cdrx/pyinstaller-linux:python2 'rm -rf build'"
        // sshPublisher(
        //     publishers: [
        //         sshPublisherDesc(
        //             configName: 'submission-cicd-pipeline-nafifurqon-ec2', 
        //             transfers: [
        //                 sshTransfer(
        //                     cleanRemote: false,
        //                     excludes: '',
        //                     execCommand: "chmod a+x ${env.BUILD_ID}/sources/dist/add2vals && ./${env.BUILD_ID}/sources/dist/add2vals 10 20",
        //                     execTimeout: 120000,
        //                     flatten: false,
        //                     makeEmptyDirs: false,
        //                     noDefaultExcludes: false,
        //                     patternSeparator: '[, ]+',
        //                     remoteDirectory: '',
        //                     remoteDirectorySDF: false,
        //                     removePrefix: '',
        //                     sourceFiles: "${env.BUILD_ID}/sources/dist/*"
        //                 )
        //             ],
        //             usePromotionTimestamp: false,
        //             useWorkspaceInPromotion: false,
        //             verbose: false
        //         )
        //     ]
        // )
        // sleep(60)
    }
}