SWEP.ViewModelFOV = 57
SWEP.ViewModel = "models/weapons/v_ihr.mdl"
SWEP.WorldModel = "models/weapons/w_ihr.mdl" 
SWEP.UseHands = true
SWEP.Slot = 4 
SWEP.HoldType = "ar2" 
SWEP.PrintName = "GrenadeLauncher(Atty)"  
SWEP.Author = "SWEPtutorial+LordiAnders(sounds)+Attache(redisygn)" 
SWEP.Spawnable = true  
SWEP.Weight = 5 
SWEP.DrawCrosshair = true 
SWEP.Category = "GrenadeLauncher" 
SWEP.SlotPos = 0 
SWEP.DrawAmmo = true  
SWEP.Instructions = "Left click, wait, KA-BOOM!"   
SWEP.Contact = ""  
SWEP.Purpose = "You hafta THINK to USE it properly" 
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 3  
SWEP.Primary.DefaultClip = 9
SWEP.Primary.ClipMax = 16
SWEP.Primary.Automatic = false 
SWEP.Primary.Ammo = "RPG_Round"  


SWEP.Secondary.ClipSize = -1                    
SWEP.Secondary.Ammo = "none"
--
function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
--
function SWEP:Reload()
	if self.Owner:GetAmmoCount( self.Primary.Ammo ) == 0 then return end
	if self:Clip1() == 6 then return end
	self:DefaultReload( ACT_VM_RELOAD ) -- animation for reloading
end

--
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:PrimaryAttack()
    if self:Clip1() <= 0 then return end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound("NPC_Combine.GrenadeLaunch")
	if SERVER then
		local grenade = ents.Create("ent_baby_explosive")
		grenade:SetOwner(self.Owner)
		grenade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
		grenade:SetAngles(self.Owner:GetAngles())
        self.Owner:MuzzleFlash()
		grenade:Spawn()
		grenade:Activate()
        self.Weapon:TakePrimaryAmmo(1)
        --self.Weapon:Reload() // If you want to make their life harder...
		local phys = grenade:GetPhysicsObject()
		phys:ApplyForceCenter(self.Owner:GetAimVector() * 1000)
		self:SetNextPrimaryFire(CurTime() + 1.2)
	end
end

function SWEP:SecondaryAttack() end
    
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end