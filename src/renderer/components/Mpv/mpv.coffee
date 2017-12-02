import { PLUGIN_MIME_TYPE } from "mpv.js"


export default {
    default:
        name: 'mpv'
        data: ->
            PLUGIN_MIME_TYPE: PLUGIN_MIME_TYPE

        props:
            onReady:
                type: Function
                default: (mpv) ->
                    console.log(mpv)

            onPropertyChange:
                type: Function
                default: (name, value) ->
                    console.log(name, value)

        mounted: ->
            @node = document.querySelector('#player')
            @node.addEventListener("message", @_handleMessage.bind(@))

        methods:
            command: (cmd, args...) ->
                args = args.map((arg) -> arg.toString())
                @_postData('command', [cmd].concat(args))

            setProperty: (name, value) ->
                @_postData('set_property', {name, value})

            observe: (name) ->
                @_postData('observe_property', name)

            _postData: (type, data) ->
                @node.postMessage({type, data})

            _handleMessage: (e) ->
                msg = e.data
                {type, data} = msg

                if type == 'property_change'
                    {name, value} = data
                    @onPropertyChange(name, value)
                else if type == 'ready'
                    @onReady(@)

            keypress: (key) ->
                @command('keypress', key)

            destroy: ->
                @node.remove()
}
