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

    stage('Manual Approve') {
        input message: 'Lanjutkan ke tahap Deploy? (Klik "Proceed" untuk melanjutkan eksekusi pipeline ke tahap Deploy atau "Abort" untuk menghentikan eksekusi pipeline)' 
    }
    
    stage('Deliver') {
        try {
            dir("${env.BUILD_ID}") {
                unstash(name: 'compiled-results')
                sh "docker run --rm -v ${env.WORKSPACE}/${env.BUILD_ID}/sources:/src cdrx/pyinstaller-linux:python2 'pyinstaller -F add2vals.py'"
            }
        } catch (e) {
            echo 'Failed'
            throw e
        } finally {
            archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
            sh "docker run --rm -v ${env.WORKSPACE}/${env.BUILD_ID}/sources:/src cdrx/pyinstaller-linux:python2 'rm -rf build'"
            sshPublisher(
                publishers: [
                    sshPublisherDesc(
                        configName: 'deploy-app-ec2', 
                        transfers: [
                            sshTransfer(
                                cleanRemote: false,
                                excludes: '',
                                execCommand: "chmod a+x ${env.BUILD_ID}/sources/dist/add2vals && ./${env.BUILD_ID}/sources/dist/add2vals 10 20",
                                execTimeout: 120000,
                                flatten: false,
                                makeEmptyDirs: false,
                                noDefaultExcludes: false,
                                patternSeparator: '[, ]+',
                                remoteDirectory: '',
                                remoteDirectorySDF: false,
                                removePrefix: '',
                                sourceFiles: "${env.BUILD_ID}/sources/dist/*"
                            )
                        ],
                        usePromotionTimestamp: false,
                        useWorkspaceInPromotion: false,
                        verbose: false
                    )
                ]
            )
            sleep time: 1, unit: 'MINUTES'
        }
    }
}