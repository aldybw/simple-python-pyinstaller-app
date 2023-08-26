node {
    docker.image('python:2-alpine').inside('-p 3000:3000'){
        stage('Build') {
            checkout scm
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
        
    }
    docker.image('qnib/pytest').inside('-p 3000:3000'){
        stage('Test') {
            checkout scm
            sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
        }
        post {
            always {
                junit 'test-reports/results.xml'
            }
        }
    }
    docker.image('cdrx/pyinstaller-linux:python2').inside('-p 3000:3000'){
        stage('Deliver') {
            checkout scm
            sh 'pyinstaller --onefile sources/add2vals.py'
        }
        post {
            success {
                archiveArtifacts 'dist/add2vals'
            }
        }
    }
}