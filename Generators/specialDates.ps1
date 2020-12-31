$map = @{
    1  = @{
        DaysInMonth = 31
        Quarter     = 1
    }

    2  = @{
        DaysInMonth = 28
        Quarter     = 1
    }

    3  = @{
        DaysInMonth = 31
        Quarter     = 1
    }

    4  = @{
        DaysInMonth = 30
        Quarter     = 2
    }

    5  = @{
        DaysInMonth = 31
        Quarter     = 2
    }

    6  = @{
        DaysInMonth = 30
        Quarter     = 2
    }

    7  = @{
        DaysInMonth = 31
        Quarter     = 3
    }

    8  = @{
        DaysInMonth = 31
        Quarter     = 3
    }
    
    9  = @{
        DaysInMonth = 30
        Quarter     = 3
    }

    10 = @{
        DaysInMonth = 31
        Quarter     = 4
    }

    11 = @{
        DaysInMonth = 30
        Quarter     = 4
    }

    12 = @{
        DaysInMonth = 31
        Quarter     = 4
    }
}

<#
    YearToDate
#>


function RandomDayOfMonth {
    param($month)
    
    Get-Random -Minimum 1 -Maximum ($map.$month.DaysInMonth + 1)
}

function RandomDateForMonth {
    param(
        $month,
        $year=()
    )
    
    $day = RandomDayOfMonth $month
    
    (Get-Date "$month/$day/$(ThisYear)").ToShortDateString()
}

function LastQuarter {
    param([datetime]$date = (Get-Date))

    &("Q" + [math]::Ceiling($date.AddMonths(-3).Month / 3)    )
}

function NextQuarter {
    param([datetime]$date = (Get-Date))

    &("Q" + [math]::Ceiling($date.AddMonths(3).Month / 3)    )
}

function LastWeek { "Not yet implemented" }
function NextWeek { "Not yet implemented" }
function YearToDate { "Not yet implemented" }
function ThisWeek { Get-Date -UFormat %V }
function ThisQuarter { &("Q" + [math]::Floor(((ThisMonth) + 2) / 3)) }
function ThisYear { (Get-Date).Year }
function ThisMonth { (Get-Date).Month }
function Today { (Get-Date).ToShortDateString() }
function Tomorrow { (Get-Date).AddDays(1).ToShortDateString() }
function Yesterday { (Get-Date).AddDays(-1).ToShortDateString() }
function LastYear { (Get-Date).AddYears(-1).ToShortDateString() }
function NextYear { (Get-Date).AddYears(-1).ToShortDateString() }
function LastMonth { (Get-Date).AddMonths(-1).ToShortDateString() }
function NextMonth { (Get-Date).AddMonths(-1).ToShortDateString() }
function Q1 { (January), (February), (March) | Get-Random }
function Q2 { (April), (May), (June) | Get-Random }
function Q3 { (July), (August), (September) | Get-Random }
function Q4 { (October), (November), (December) | Get-Random }
function January { RandomDateForMonth 1 }
function February { RandomDateForMonth 2 }
function March { RandomDateForMonth 3 }
function April { RandomDateForMonth 4 }
function May { RandomDateForMonth 5 }
function June { RandomDateForMonth 6 }
function July { RandomDateForMonth 7 }
function August { RandomDateForMonth 8 }
function September { RandomDateForMonth 9 }
function October { RandomDateForMonth 10 }
function November { RandomDateForMonth 11 }
function December { RandomDateForMonth 12 }