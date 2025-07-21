-- 请在这里填写你的个人信息
local config = {
    password      = "YOUR_PASSWORD_HERE", -- 【请替换成你的真实密码】
    secret_2fa    = "YOUR_2FA_SECRET_HERE", -- 【请替换成你的2FA Secret】
    oathtool_path = "/opt/homebrew/bin/oathtool" -- oathtool 路径
}


-- 主脚本逻辑
-- 默认用户名已被记住，光标在用户名处，直接输入密码即可。
function loginToEasyConnect()
    -- 步骤 1: 启动 EasyConnect
    hs.alert.show("启动 EasyConnect...\n将在10秒后自动操作。")
    
    local app = hs.application.launchOrFocus("EasyConnect")
    if not app then
        hs.alert.show("错误：找不到 EasyConnect.app", {fillColor = {red=1}})
        return
    end

    -- 步骤 2: 使用固定延迟等待应用加载
    local initialWait = 10
    hs.alert.show(string.format("正在等待 %d 秒让应用完全加载...", initialWait))

    hs.timer.doAfter(initialWait, function()
        hs.alert.show("等待结束，开始操作...")

        -- 按 Tab 将焦点从用户名移到密码框
        hs.eventtap.keyStroke({}, "tab")
        
        hs.timer.doAfter(0.5, function()
            -- 直接输入密码
            hs.eventtap.keyStrokes(config.password)
            
            hs.timer.doAfter(0.5, function()
                -- 按 Enter 提交登录
                hs.eventtap.keyStroke({}, "return")
                
                -- 进入下一步
                process2FA()
            end)
        end)
    end)
end

function process2FA()
    hs.alert.show("登录信息已提交，等待 5 秒加载 2FA 页面...")
    
    hs.timer.doAfter(5, function()
        hs.alert.show("正在获取 2FA 验证码...")

        local task = hs.task.new(config.oathtool_path, function(exitCode, stdOut, stdErr)
            if exitCode == 0 and stdOut then
                local code = string.match(stdOut, "%d+")
                if code and #code == 6 then
                    hs.alert.show("已获取验证码：" .. code .. "，正在输入...")
                    hs.eventtap.keyStrokes(code)
                    hs.timer.doAfter(0.5, function()
                        hs.eventtap.keyStroke({}, "return")
                        hs.alert.show("VPN 登录流程完成", {soundName = "Glass"})
                    end)
                else
                    hs.alert.show("错误：oathtool 未返回有效的6位验证码\n" .. (stdOut or ""), {fillColor = {red=1}})
                end
            else
                hs.alert.show("错误：执行 oathtool 失败\n" .. (stdErr or ""), {fillColor = {red=1}})
            end
        end, {"--totp", "-b", config.secret_2fa})

        task:start()
    end)
end


-- 绑定快捷键
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "E", function()
    loginToEasyConnect()
end)

hs.alert.show("EasyConnect 自动登录脚本\n按 Ctrl+Alt+Cmd+E 启动。")
