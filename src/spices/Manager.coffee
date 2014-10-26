minimist = require 'minimist'
_ = require 'underscore-node'
Q = require 'q'

class CommandManager
  constructor: (@commands = {}) ->

  addCommands: (commands) =>
    _.extend(@commands, commands)
    
  run: =>
    args = minimist(@_getArguments())
    commandName = args['_'].shift()
    if commandName
      @_launchCommand(commandName, args)
    else
      @_printInformation()

  _getArguments: =>
    process.argv[2...]
      
  _launchCommand: (commandName, args) =>
    command = @commands[commandName]
    if !command
      console.error('Error: no command found matching "' + commandName + '"')
      @_exit(1)
    promise = Q.when(command.run(args))
    promise.then((data) =>
      @_exit()
    , (error) =>
      @_exit(1, error)
    )
    
  _printInformation: =>
    console.log('Available commands:')
    for commandName, command of @commands
      console.log('\t' + commandName + '\t' + command.description)
    @_exit()
    
  _exit: (status = 0, error = undefined) =>
    if error
      console.error(error)
    process.exit(status)
    
module.exports = CommandManager