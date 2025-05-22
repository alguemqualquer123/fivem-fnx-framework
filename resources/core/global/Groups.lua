Groups = {
    ["Admin"] = {
        ["Parent"] = false, -- Grupo raiz
        ["IsServiceGroup"] = false,
        ["Hierarchy"] = {
            ["Fundador"] = {
                ["Parent"] = false,
                ["Permissions"] = {"all"},
                ["Salary"] = 0
            },
            ["Head-Staff"] = {
                ["Parent"] = {"Fundador"},
                ["Permissions"] = {"ban", "kick", "manage_staff"},
                ["Salary"] = 0
            },
            ["Staff"] = {
                ["Parent"] = {"Head-Staff"},
                ["Permissions"] = {"kick", "warn"},
                ["Salary"] = 0
            },
            ["Suporte"] = {
                ["Parent"] = {"Staff"},
                ["Permissions"] = {"help_users"},
                ["Salary"] = 0
            }
        }
    },

    -- Grupo Premium
    ["Premium"] = {
        ["Parent"] = false,
        ["IsServiceGroup"] = false,
        ["Hierarchy"] = {
            ["Platina"] = {
                ["Parent"] = false,
                ["Permissions"] = {"premium_spawn", "extra_vehicles"},
                ["Salary"] = 5000
            },
            ["Ouro"] = {
                ["Parent"] = {"Platina"},
                ["Permissions"] = {"extra_vehicles"},
                ["Salary"] = 4000
            },
            ["Prata"] = {
                ["Parent"] = {"Ouro"},
                ["Permissions"] = {},
                ["Salary"] = 3200
            }
        }
    },

    -- Polícia
    ["Policia"] = {
        ["Parent"] = false,
        ["IsServiceGroup"] = true,
        ["Hierarchy"] = {
            ["Comandante"] = {
                ["Parent"] = false,
                ["Permissions"] = {"manage_police", "police_armory", "high_command"},
                ["Salary"] = 6000
            },
            ["Tenente"] = {
                ["Parent"] = {"Comandante"},
                ["Permissions"] = {"police_armory", "manage_patrols"},
                ["Salary"] = 5000
            },
            ["Sargento"] = {
                ["Parent"] = {"Tenente"},
                ["Permissions"] = {"police_armory"},
                ["Salary"] = 4500
            },
            ["Soldado"] = {
                ["Parent"] = {"Sargento"},
                ["Permissions"] = {"basic_police_duties"},
                ["Salary"] = 4000
            }
        }
    },

    -- EMS
    ["EMS"] = {
        ["Parent"] = false,
        ["IsServiceGroup"] = true,
        ["Hierarchy"] = {
            ["Diretor"] = {
                ["Parent"] = false,
                ["Permissions"] = {"manage_ems", "ems_supplies"},
                ["Salary"] = 6000
            },
            ["Médico Chefe"] = {
                ["Parent"] = {"Diretor"},
                ["Permissions"] = {"ems_supplies", "handle_critical"},
                ["Salary"] = 5000
            },
            ["Paramédico"] = {
                ["Parent"] = {"Médico Chefe"},
                ["Permissions"] = {"revive", "heal"},
                ["Salary"] = 4500
            },
            ["Resgatista"] = {
                ["Parent"] = {"Paramédico"},
                ["Permissions"] = {"basic_ems_duties"},
                ["Salary"] = 4000
            }
        }
    }
}
