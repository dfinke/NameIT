function Convert-DataTypeToNameIt {
    param($dataType)

    switch ($dataType) {
        "int" {"numeric 5"}
        "string" {"alpha 6"}
        default {"alpha 6"}
    }
}
