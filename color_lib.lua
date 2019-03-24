Color =
{
  white =    {255/255, 255/255, 255/255, 255/255},
  black =    {0/255  , 0/255  , 0/255  , 255/255},
  red =      {255/255, 0/255  , 0/255  , 255/255},
  pink =     {220/255, 160/255, 160/255, 255/255},
  green =    {0/255  , 255/255, 0/255  , 255/255},
  blue =     {0/255  , 0/255  , 255/255, 255/255},
  blue_lite ={128/255, 220/255, 255/255, 255/255},
  yellow =   {255/255, 255/255, 0/255  , 255/255},
  purple =   {255/255, 0/255  , 255/255, 255/255},
  orange =   {255/255, 128/255, 0/255  , 255/255},
  grey =     {64/255 , 64/255 , 64/255 , 255/255},
  grey_lite ={128/255, 128/255, 128/255, 255/255},
  grey_dark ={32/255 , 32/255 , 32/255 , 255/255},
}
  
love.graphics.setBackgroundColor(Color.grey_dark)

setColor = love.graphics.setColor

Color.alpha = function(color_string, a)
  local c = Color[color_string]
  c[4] = a
  return c
end
