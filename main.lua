require "dependencies"

local thing = {
    ["name"] = "Mads",
    ["age"] = 44,
}

local birthdayHandler = Event.on('birthday', function(birthdayNoy)
    birthdayNoy.age = birthdayNoy.age + 1
end)

Event.dispatch('birthday', thing)

print("Age: " .. tostring(thing.age))

birthdayHandler:remove()

Event.dispatch('birthday', thing)

print("Age: " .. tostring(thing.age))
