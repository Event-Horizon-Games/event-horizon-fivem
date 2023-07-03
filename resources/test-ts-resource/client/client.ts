import { myRandomData } from "./MyOther.client";

on('onResourceStart', (resName: string) => {
    emit('chat:addMessage', {
        args: [
            "The resource is working"
        ]
    })
})