winston = require 'winston'

exports.Postmark = winston.transports.Postmark = class Postmark extends winston.Transport
  constructor: (options) ->
    @name = 'postmark'
    @level = options.level || 'info'
    @silent = options.silent || false
    @handleExceptions = options.handleExceptions || false

    @postmarkApiKey = options.postmarkApiKey || ''
    @postmarkFrom = options.postmarkFrom || ''
    @postmarkTo = options.postmarkTo || ''
    @postmarkSubject = options.postmarkSubject || ''

    @postmark = require('postmark')(@postmarkApiKey)

  log: (level, msg, meta, callback) ->
    if (@silent)
      return callback null, true
    @postmark.send
      'From': @postmarkFrom,
      'To': @postmarkTo,
      'Subject': @postmarkSubject,
      'HtmlBody': "<code>#{JSON.stringify(msg,undefined,4)}</code><br/><br/><br/><code>#{JSON.stringify(meta,undefined,4)}</code>",
      'TextBody': "#{JSON.stringify(msg,undefined,4)}\n\n\n#{JSON.stringify(meta,undefined,4)}"
    callback null, true
