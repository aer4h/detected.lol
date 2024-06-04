local aimbotEnabled = false
local lockedTarget = nil

game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.Z then
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled and lockedTarget then
            game.StarterGui:SetCore("SendNotification", {
                Title = "detected.lol | back to basic";
                Text = lockedTarget.Name;
                Duration = 5;
            })
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        local mouse = game.Players.LocalPlayer:GetMouse()
        local cursorPosition = Vector2.new(mouse.X, mouse.Y)
        
        if not lockedTarget then
            local targetPlayer = nil
            local shortestDistance = math.huge

            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                        local rootPosition = character.HumanoidRootPart.Position
                        local screenPosition, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(rootPosition)

                        if onScreen then
                            local playerCursorPosition = Vector2.new(screenPosition.X, screenPosition.Y)
                            local distance = (cursorPosition - playerCursorPosition).magnitude

                            if distance < shortestDistance then
                                targetPlayer = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end

            lockedTarget = targetPlayer
            if aimbotEnabled and lockedTarget then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "detected.lol";
                    Text = lockedTarget.Name;
                    Duration = 5;
                })
            end
        end

        if lockedTarget then
            local headPosition = lockedTarget.Character.Head.Position
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, headPosition)
        end
    else
        lockedTarget = nil
    end
end)
