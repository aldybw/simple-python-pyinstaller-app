node {
    
    stage('Build') {
        docker.image('python:2-alpine').inside {
            checkout scm
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    
    stage('Test') {
        docker.image('qnib/pytest').inside {
            checkout scm
            sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            
        }
    }
    // docker.image('cdrx/pyinstaller-linux:python2').inside('-p 3000:3000'){
    //     stage('Deliver') {
    //         checkout scm
    //         sh 'pyinstaller --onefile sources/add2vals.py'
    //     }
    //     post {
    //         success {
    //             archiveArtifacts 'dist/add2vals'
    //         }
    //     }
    // }
}