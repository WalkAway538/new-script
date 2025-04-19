-- Made by WalkAway538 & ChatGPT - Custom Hub Script

local Players = game:GetService("Players") local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local player = Players.LocalPlayer local character = player.Character or player.CharacterAdded:Wait() local humanoid = character:WaitForChild("Humanoid") local hrp = character:WaitForChild("HumanoidRootPart")

-- Create UI local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) gui.Name = "CustomHub"

local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 300, 0, 400) frame.Position = UDim2.new(0.5, -150, 0.5, -200) frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true

local uilist = Instance.new("UIListLayout", frame) uilist.Padding = UDim.new(0, 8) uilist.FillDirection = Enum.FillDirection.Vertical uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center uilist.VerticalAlignment = Enum.VerticalAlignment.Top uilist.SortOrder = Enum.SortOrder.LayoutOrder

-- Close Button local closeBtn = Instance.new("TextButton", frame) closeBtn.Size = UDim2.new(1, -20, 0, 30) closeBtn.Text = "Close UI" closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30) closeBtn.TextColor3 = Color3.new(1, 1, 1) closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Utility: Create Toggle Button local toggles = {} local function makeToggle(name, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -20, 0, 30) btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btn.TextColor3 = Color3.new(1, 1, 1) btn.Text = name .. ": OFF" local state = false

btn.MouseButton1Click:Connect(function()
    state = not state
    btn.Text = name .. (state and ": ON" or ": OFF")
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    callback(state)
end)

end

-- Fly local flying = false local flyVelocity = Instance.new("BodyVelocity") flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5) flyVelocity.Velocity = Vector3.zero flyVelocity.Name = "FlyVelocity"

makeToggle("Fly", function(state) flying = state if state then flyVelocity.Parent = hrp else flyVelocity.Parent = nil end end)

RunService.RenderStepped:Connect(function() if flying then local moveVec = Vector3.new(0, 0, 0) if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += workspace.CurrentCamera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= workspace.CurrentCamera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= workspace.CurrentCamera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += workspace.CurrentCamera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0, 1, 0) end flyVelocity.Velocity = moveVec.Unit * 70 end end)

-- Speed makeToggle("Speed Boost", function(state) humanoid.WalkSpeed = state and 100 or 16 end)

-- Anti-Fling makeToggle("Anti-Fling", function(state) if state then character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(1000, 1000, 1000) else character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5) end end)

-- NoClip local noclip = false makeToggle("NoClip", function(state) noclip = state end)

RunService.Stepped:Connect(function() if noclip then for _, v in pairs(character:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end end)

-- Auto Jump makeToggle("Auto Jump", function(state) toggles.AutoJump = state end)

RunService.RenderStepped:Connect(function() if toggles.AutoJump and humanoid:GetState() == Enum.HumanoidStateType.Freefall then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- ESP (Simple Name Tag) makeToggle("ESP", function(state) for _, p in pairs(Players:GetPlayers()) do if p ~= player then local char = p.Character if char and char:FindFirstChild("Head") then local tag = char.Head:FindFirstChild("NameTag") if state and not tag then local billboard = Instance.new("BillboardGui", char.Head) billboard.Name = "NameTag" billboard.Size = UDim2.new(0, 100, 0, 20) billboard.AlwaysOnTop = true local label = Instance.new("TextLabel", billboard) label.Size = UDim2.new(1, 0, 1, 0) label.Text = p.Name label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.TextScaled = true elseif not state and tag then tag:Destroy() end end end end end)

