local HttpService = game:GetService("HttpService")

local function sendSignal(signal)
    for port = 27842, 27861 do
        local success = pcall(function()
            local url = "http://127.0.0.1:" .. port .. "/" .. signal
            if syn and syn.request then
                syn.request({Url = url, Method = "GET"})
            elseif http and http.request then
                http.request({Url = url, Method = "GET"})
            else
                HttpService:GetAsync(url)
            end
        end)
        if success then
            return
        end
    end
end

task.spawn(function()
    sendSignal("show") 

    task.wait(2.5)
    sendSignal("hide")
end)