;; This skill file compiles schematic PCells for BAG resistor primitives
; res_standard/rspp
pcDefinePCell(
    list( ddGetObj("BAG_prim") "res_standard" "schematic" "schematic")
    ((w string "1u")
     (l string "2u")
    )
    let((inst iopin_master io_net io_pin)
        inst = dbCreateParamInstByMasterName( pcCellView "cds_ff_mpt" "rspp" "symbol"
                                              "R0" 0.5:0 "R270" 1
                                              list(list("w" "float" cdfParseFloatString(w))
                                                   list("l" "float" cdfParseFloatString(l))
                                                  )
                                            )
        iopin_master = dbOpenCellViewByType("basic" "iopin" "symbolr" nil "r")
        io_net = dbCreateNet(pcCellView "PLUS")
        io_pin = dbCreatePin(io_net dbCreateInst(pcCellView iopin_master "PLUS" 1:0 "R0")
                             "PLUS" dbCreateTerm(io_net "PLUS" "inputOutput"))
        dbCreateInstTerm(io_net inst dbFindTermByName(inst~>master "PLUS"))
        io_net = dbCreateNet(pcCellView "MINUS")
        io_pin = dbCreatePin(io_net dbCreateInst(pcCellView iopin_master "MINUS" -0.15:0 "R0")
                             "MINUS" dbCreateTerm(io_net "MINUS" "inputOutput"))
        dbCreateInstTerm(io_net inst dbFindTermByName(inst~>master "MINUS"))

        ; dbCreateSigNetExpr(io_net "[@sub:%:sub!]")
    )
)

; res_metal/metalres
pcDefinePCell(
    list( ddGetObj("BAG_prim") "res_metal" "schematic" "schematic")
    ((w string "1u")
     (l string "2u")
     (layer string "5")
    )
    let((inst iopin_master io_net io_pin cdf_layer cdf_layer_name)
        ; layer_index   |   layer_name  | gds / metalres number
        ;   1                   M1
        ;   2                   M2
        ;   3                   M3
        ;   4                   M4
        ;   5                   M5
        ;   6                   M6
        ;   7                   M7
        ;   8                   MT

        res_name = case( layer
            ("1" "resm1")
            ("2" "resm2")
            ("3" "resm3")
            ("4" "resm4")
            ("5" "resm5")
            ("6" "resm6")
            ("7" "resm7")
            ("8" "resmt")
            (t (error "BAG_prim res_metal: Unrecognized layer number"))
        )


        inst = dbCreateParamInstByMasterName( pcCellView "cds_ff_mpt" res_name "symbol"
                                              "R0" 0.1:0 "R90" 1
                                              list(list("w" "float" cdfParseFloatString(w))
                                                   list("l" "float" cdfParseFloatString(l))
                                                   list("effw" "float" cdfParseFloatString(w))
                                                   list("effl" "float" cdfParseFloatString(l))
                                                  )
                                            )

        iopin_master = dbOpenCellViewByType("basic" "iopin" "symbolr" nil "r")
        io_net = dbCreateNet(pcCellView "PLUS")
        io_pin = dbCreatePin(io_net dbCreateInst(pcCellView iopin_master "PLUS" -0.15:0 "R0")
                             "PLUS" dbCreateTerm(io_net "PLUS" "inputOutput"))
        dbCreateInstTerm(io_net inst dbFindTermByName(inst~>master "PLUS"))
        io_net = dbCreateNet(pcCellView "MINUS")
        io_pin = dbCreatePin(io_net dbCreateInst(pcCellView iopin_master "MINUS" 1.15:0 "R0")
                             "MINUS" dbCreateTerm(io_net "MINUS" "inputOutput"))
        dbCreateInstTerm(io_net inst dbFindTermByName(inst~>master "MINUS"))
        ; dbCreateSigNetExpr(io_net "[@sub:%:sub!]")
    )
)
