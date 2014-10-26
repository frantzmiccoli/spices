Intentions
===

**spices** goal is too provide a convenient way to provide command-line tools
from a node.js applications.

The goal has been to provide the same kind of behavior as what can be seen in
[Symfony2's command system](http://symfony.com/doc/current/cookbook/console/console_command.html).

Setup
===

Installation
---

    npm install spices

Configuration
---

myapp/mycommand.js describes a command.

``` js
module.exports = {
    description: 'This command has to do something',
    run: function(myArguments) {
        console.log('The command is running with the provided arguments', myArguments);
    }
};
```

myapp/commands.js describes all the commands for our module.

``` js
myCommand = require("myapp/mycommand.js");

module.exports = {
    // the name could be anything
    'myapp:mycommand': myCommand
}
```

command.js: now you have to provide a file to actually call to run your commands:

``` js
appCommands = require('myapp/commands')

commandManager = require('spices')();

// we could also have directly call
// commandManager = require('spices')(appCommands);
commandManager.addCommands(appCommands);

commandManager.run();
```

Let the magic happens:

```bash
node command.js # provides a list of the available commands
node commands.js myapp:mycommand "some extra arguments" -a 1 2 3
```

Documentation
===

You don't need to know much more than what is described above but two
exceptions.

Promises
---

**spices** handles promises. So if your command returns a promise
**spices** will wait for its fulfillment to return.

Arguments
---

**spices** uses [minimist](https://github.com/substack/minimist) and what your
command receives kept the format minimist provides. What interests you lives
inside the '_' of the provided dictionary.