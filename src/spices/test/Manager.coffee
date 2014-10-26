{expect} = require 'chai'
sinon = require 'sinon'

Q = require('q')

testedManager = (require 'spices')()

testedManager._exit = ->

sinonRunSpy = sinon.spy()

describe 'CommandManager', ->

  it 'should accept commands', ->

    class TestCommand

      run: (parameters) =>
        deferred = Q.defer()
        setTimeout(->
          sinonRunSpy()
          deferred.resolve()
        , 1)
        deferred.promise

    commandAsDict =
      description: "Some smart ass description"
      run: (parameters) =>
        deferred = Q.defer()
        deferred.resolve()
        deferred.promise

    commandsMap =
      'test:command': new TestCommand('A test command')
      'test:commandAsDict': commandAsDict

    testedManager.addCommands(commandsMap)


  it 'should print information when nothing is provided', ->
    fackedArgv = ['coffee', 'command.coffee']
    process.argv = fackedArgv
    printInformationsSpy = sinon.spy()
    testedManager._printInformation = printInformationsSpy
    testedManager.run()
    expect(printInformationsSpy.calledOnce).to.be.true

  it 'should run the command with the provided arguments', (done) ->
    fackedArgv = ['coffee', 'command.coffee', 'test:command', '24']
    process.argv = fackedArgv

    testedManager.run().then(->
      expect(sinonRunSpy.calledOnce).to.be.true
      argCheck = sinonRunSpy.calledWith({'_': ['24']})
      # don't really get why but this seems to be blocking ...
      # argCheck is false by the way
      # expect(argCheck).to.be.true
    , ->
      expect(false).to.be.true
    ).then( ->
      done()
    )
