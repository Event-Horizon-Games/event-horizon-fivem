RegisterCommand('typescript-hello', (source: number) => {
  TriggerClientEvent("chatMessage", source, "Hello it ")
}, false)
