
-- name="demo1"

ltp=true

logger = {
    file = "/tmp/moochine_demo1.log",
    level = "ERROR",
}

debug={
    on=true,
    to="response", -- "ngx.log"
}

config={
    templates="templates",
}

subapps={
    demo3 = {
        path="/Volumes/KDr2/Work/appwill/moochine/demos/demo3",
        config={
            test="a test config",
            ltp=true
        }
    },
}


