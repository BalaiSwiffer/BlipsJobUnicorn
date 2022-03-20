--#########################--
--######### Blips #########-- # Les blips sont uniquement visible avec le job Unicorn
--#########################--

local ESX, PlayerData = exports["es_extended"]:getSharedObject();

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(player)
  ESX.PlayerData = player;
  PlayerLoaded = true
end)

---@public
---@class jobBlipsClient_Storage
jobBlipsClient_Storage = {};

---@private
---@type table jobBlips
local jobBlips = {
  ["unicorn"] = {
      {
          position = vector3(-2955.242, 385.897, 14.041), name = "Stock Alcool", job = 'unicorn', sprite = 121, scale = 0.6, colour = 3, 
      },
      {
          position = vector3(178.028, 307.467, 104.392), name = "Stock sans Alcool", job = 'unicorn', sprite = 121, scale = 0.6, colour = 3,
      },
      {
          position = vector3(499.5893, -659.8500, 23.8927), name = "Stock Apéro", job = 'unicorn', sprite = 121, scale = 0.6, colour = 3,
      },
      {
          position = vector3(-710.9782, -910.2581, 18.2155), name = "Stock de Glace", job = 'unicorn', sprite = 121, scale = 0.6, colour = 3,
      },
      
          
  }
};

---@private
---@type function createBlips
---@param data table
local function createBlips(data)
  local blip = AddBlipForCoord(data.pos)
  SetBlipSprite(blip, data.sprite)
  SetBlipScale(blip, data.scale)
  SetBlipColour(blip, data.colour)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString(data.name)
  EndTextCommandSetBlipName(blip)
  return blip;
end

---@private
---@type function verifyPlayerJob
function verifyPlayerJob()
  ESX.PlayerData = ESX.GetPlayerData();

  if (ESX.PlayerData ~= nil) then
      local haveJob = false
      if (ESX.PlayerData.job.name ~= 'unemployed') then
          haveJob = true;
      end

      if (#jobBlipsClient_Storage > 0) then
          for _,v in pairs(jobBlipsClient_Storage) do
              if (v.job ~= ESX.PlayerData.job.name) then
                  RemoveBlip(v.blip);
                  jobBlipsClient_Storage = {  };
              end
          end
      else
          if (haveJob) then
              local playerJob = (ESX.PlayerData.job.name or "unemployed");

              if jobBlips[playerJob] ~= nil then
                for _,v in pairs(jobBlips[playerJob]) do
                    if (v.job == "unemployed") then return end

                    if (v.job == playerJob) then
                        local blips = createBlips({ pos = v.position, sprite = v.sprite, scale = v.scale, colour = v.colour, name = v.name });
                        table.insert(jobBlipsClient_Storage, {blip = blips, job = v.job})
                    end
                end
              end
          end
      end
  end
end

CreateThread(function()
  if (ESX.GetPlayerData().job ~= nil) then
      PlayerLoaded = true
  end

  while (not PlayerLoaded) do
      Wait(1000.0);
  end

  while (PlayerLoaded) do
      local tick = 1450;
      verifyPlayerJob();

      Wait(tick)
  end
end)