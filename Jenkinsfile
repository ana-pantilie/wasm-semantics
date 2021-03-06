pipeline {
  agent {
    dockerfile {
      reuseNode true
    }
  }
  options {
    ansiColor('xterm')
  }
  stages {
    stage('Init title') {
      when { changeRequest() }
      steps {
        script {
          currentBuild.displayName = "PR ${env.CHANGE_ID}: ${env.CHANGE_TITLE}"
        }
      }
    }
    stage('Build and Test') {
      when { changeRequest() }
      stages {
        stage('Dependencies') {
          steps {
            sh '''
              make deps
            '''
          }
        }
        stage('Build') {
          steps {
            sh '''
              make build -j4
            '''
          }
        }
        stage('Test Simple') {
          options { timeout(time: 5, unit: 'MINUTES') }
          parallel {
            stage('Exec Java (Floating Point)') {
              steps {
                sh '''
                  nprocs=$(nproc)
                  [ "$nprocs" -gt '4' ] && nprocs=4
                  make TEST_CONCRETE_BACKEND=java test-simple-float -j"$nprocs"
                '''
              }
            }
            stage('Exec LLVM') {
              steps {
                sh '''
                  nprocs=$(nproc)
                  [ "$nprocs" -gt '4' ] && nprocs=4
                  make TEST_CONCRETE_BACKEND=llvm test-simple -j"$nprocs"
                '''
              }
            }
          }
        }
        stage('Test Conformance') {
          options { timeout(time: 15, unit: 'MINUTES') }
          parallel {
            stage('Parse') {
              steps {
                sh '''
                  nprocs=$(nproc)
                  [ "$nprocs" -gt '4' ] && nprocs=4
                  make test-conformance-parse -j"$nprocs"
                '''
              }
            }
            stage('Exec LLVM') {
              steps {
                sh '''
                  nprocs=$(nproc)
                  [ "$nprocs" -gt '4' ] && nprocs=4
                  make TEST_CONCRETE_BACKEND=llvm test-conformance-supported -j"$nprocs"
                '''
              }
            }
          }
        }
        stage('Test Proofs') {
          options { timeout(time: 10, unit: 'MINUTES') }
          parallel {
            stage('Normal') {
              steps {
                sh '''
                  make test-prove -j4
                '''
              }
            }
            stage('KLab') {
              steps {
                sh '''
                  make test-klab-prove -j4
                '''
              }
            }
          }
        }
      }
    }
    stage('Master Release') {
      when { branch 'master' }
      steps {
        build job: 'rv-devops/master', propagate: false, wait: false                                                   \
            , parameters: [ booleanParam(name: 'UPDATE_DEPS_SUBMODULE', value: true)                                   \
                          , string(name: 'PR_REVIEWER', value: 'ehildenb')                                             \
                          , string(name: 'UPDATE_DEPS_REPOSITORY', value: 'runtimeverification/polkadot-verification') \
                          , string(name: 'UPDATE_DEPS_SUBMODULE_DIR', value: 'deps/wasm-semantics')                    \
                          ]
      }
    }
  }
}
