

con <- file("Regionale_Kerncijfer_110412164450.csv", 'rt', encoding="latin1")
data <- readLines(con)
close(con)
data <- data[c(-(1:7), -9)]
con <- textConnection(data)
data <- read.csv2(con, dec='.')
close(con)


# ==== BASIS ====
names(data)[names(data) == "X"] <- "gemeentenaam"
names(data)[names(data) == "Onderwerpen"] <- "jaar"
names(data)[names(data) == "Totale.bevolking"] <- "totale_bevolking"
names(data)[names(data) == "Bevolkingsdichtheid"] <- "dichtheid"
names(data)[names(data) == "Totale.oppervlakte.1"] <- "oppervlakte_totaal"
names(data)[names(data) == "Land"] <- "oppervlakte_land"
names(data)[names(data) == "Koppelvariabele.regio..code."] <- "gemeentecode"

# ==== DEMOGRAFIE ====
# geslacht
names(data)[names(data) == "Mannen"]  <- "mannen"
names(data)[names(data) == "Vrouwen"] <- "vrouwen"
data$mannen  <- 100*(data$mannen / data$totale_bevolking)
data$vrouwen <- 100*(data$vrouwen / data$totale_bevolking)

# leeftijd
names(data)[names(data) == "Jonger.dan.5.jaar"] <- "lft_0_5"
names(data)[names(data) == "X5.tot.10.jaar"]    <- "lft_5_10"
names(data)[names(data) == "X10.tot.15.jaar"]   <- "lft_10_15"
names(data)[names(data) == "X15.tot.20.jaar"]   <- "lft_15_20"
names(data)[names(data) == "X20.tot.25.jaar"]   <- "lft_20_25"
names(data)[names(data) == "X25.tot.45.jaar"]   <- "lft_25_45"
names(data)[names(data) == "X45.tot.65.jaar"]   <- "lft_45_65"
names(data)[names(data) == "X65.tot.80.jaar"]   <- "lft_65_80"
names(data)[names(data) == "X80.jaar.of.ouder"] <- "lft_80"
data$lft_0_15  <- data$lft_0_5 + data$lft_5_10 + data$lft_10_15
data$lft_15_65 <- data$lft_15_20 + data$lft_20_25 + data$lft_25_45 + data$lft_45_65
data$lft_65    <- data$lft_65_80 + data$lft_80
data[c("lft_0_5", "lft_5_10", "lft_10_15", "lft_15_20", "lft_20_25", "lft_25_45", "lft_45_65", "lft_65_80", "lft_80")] <- list()

# burgerlijke staat
names(data)[names(data) == "Inwoners.15.jaar.of.ouder"] <- "bevolking_15"
names(data)[names(data) == "Ongehuwd"] <- "ongehuwd"
names(data)[names(data) == "Gehuwd"] <- "gehuwd"
names(data)[names(data) == "Gescheiden"] <- "gescheiden"
names(data)[names(data) == "Verweduwd"] <- "verweduwd"
names(data)[names(data) == "Autochtonen"] <- "autochtoon"
data$bevolking_15 <- NULL

# etniciteit
names(data)[names(data) == "Totaal.allochtonen"] <- "totaal_allochtoon"
names(data)[names(data) == "Westerse.allochtonen"] <- "westers_allochtoon"
names(data)[names(data) == "Totaal.niet.westerse.allochtonen"] <- "niet_westers_allochtoon"
names(data)[names(data) == "Marokko"] <- "allochtoon_marokko"
names(data)[names(data) == "X.Voormalige..Ned..Antillen.en.Aruba"] <- "allochtoon_antillen_aruba"
names(data)[names(data) == "Suriname"] <- "allochtoon_suriname"
names(data)[names(data) == "Turkije"] <- "allochtoon_turkije"
names(data)[names(data) == "Overige.niet.westerse.allochtonen"] <- "allochtoon_overig_niet_westers"
vars <- c("totaal_allochtoon", "westers_allochtoon", "niet_westers_allochtoon",
    "allochtoon_marokko", "allochtoon_antillen_aruba", "allochtoon_suriname", "allochtoon_turkije",
    "allochtoon_overig_niet_westers")
for (var in vars) {
  if (!is.numeric(data[,var])) {
    data[,var] <- as.numeric(as.character(data[,var]))
    data[is.na(data[,var]), var] <- 0
  }
}

# geboorte sterfte (cijfers ontbreken voor 2010 -> wis)
names(data)[names(data) == "Geboorte..relatief"] <- "geboorte"
names(data)[names(data) == "Sterfte..relatief"] <- "sterfte"
names(data)[names(data) == "Geboorteoverschot..relatief"] <- "geboorteoverschot"
names(data)[names(data) == "Nieuwvormingen"] <- "doodsoorzaken_nieuwvormingen"
names(data)[names(data) == "Ziekten.van.hart..en.vaatstelsel"] <- "doodsoorzaken_ziekten_hart_vaatstelsel"
names(data)[names(data) == "Ziekten.van.ademhalingsstelsel"] <- "doodsoorzaken_ziekten_ademhalingstelsen"
names(data)[names(data) == "Uitwendige.doodsoorzaken"] <- "doodsoorzaken_uitwendig"
names(data)[names(data) == "Overige.doodsoorzaken"] <- "doodsoorzaken_overig"
names(data)[names(data) == "Bevolkingsgroei..relatief"] <- "bevolkingsgroei"
data[c("geboorte", "sterfte", "geboorteoverschot", "doodsoorzaken_nieuwvormingen", 
    "doodsoorzaken_ziekten_hart_vaatstelsel", "doodsoorzaken_ziekten_ademhalingstelsen",
    "doodsoorzaken_uitwendig", "doodsoorzaken_overig", "bevolkingsgroei")] <- list()

# huishoudens
names(data)[names(data) == "Eenpersoonshuishoudens"] <- "eenpersoonshuishoudens"
names(data)[names(data) == "Huishoudens.zonder.kinderen"] <- "huishoudens_zonder_kinderen"
names(data)[names(data) == "Huishoudens.met.kinderen"] <- "huishoudens_met_kinderen"
names(data)[names(data) == "Gemiddelde.huishoudensgrootte"] <- "gemiddelde_huishoudensgrootte"

# ==== WONEN ====
names(data)[names(data) == "Totaal"] <- "woningvoorraad"
names(data)[names(data) == "Koopwoningen"] <- "woningvoorraad_koopwoningen"
names(data)[names(data) == "Huurwoningen"] <- "woningvoorraad_huurwoningen"
names(data)[names(data) == "Saldo.vermeerdering.woningen..relatief"] <- "woningvoorraad_toename"
names(data)[names(data) == "Woningdichtheid"] <- "woningdichtheid"
names(data)[names(data) == "Gemiddelde.woningwaarde"] <- "gemiddelde_woningwaarde"
data[c("woningvoorraad", "woningvoorraad_koopwoningen", "woningvoorraad_huurwoningen",
    "woningvoorraad_toename", "woningdichtheid")] <- list()


# ==== ONDERWIJS ====
names(data)[names(data) == "Voortgezet.onderwijs"] <- "voortgezet_onderwijs"
names(data)[names(data) == "Beroepsopleidende.leerweg"] <- "beroepsopleidende_leerweg"
names(data)[names(data) == "Beroepsbegeleidende.leerweg"] <- "beroepsbegeleidende_leerweg"
names(data)[names(data) == "Hoger.beroepsonderwijs"] <- "hoger_beroepsonderwijs"
names(data)[names(data) == "Wetenschappelijk.onderwijs"] <- "wetenschappelijk_onderwijs"
data[c("voortgezet_onderwijs", "beroepsopleidende_leerweg", "beroepsbegeleidende_leerweg", 
    "hoger_beroepsonderwijs", "wetenschappelijk_onderwijs")] <- list()


# ==== ARBEID ====
# banen
names(data)[names(data) == "A.B.Landbouw..bosbouw.en.visserij"] <- "banen_a_b_landbouw_bosbouw_visserij"
names(data)[names(data) == "C.F.Nijverheid.en.energievoorzieninig"] <- "banen_c_f_nijverheid_energievoorziening"
names(data)[names(data) == "G.K.Commerciële.dienstverlening"] <- "banen_g_k_commerciele_dienstverlening"
names(data)[names(data) == "L.O.Niet.commerciële.dienstverlening"] <- "banen_l_o_niet_commerciele_dienstverlening"
data[c("banen_a_b_landbouw_bosbouw_visserij", "banen_c_f_nijverheid_energievoorziening", "banen_g_k_commerciele_dienstverlening",
    "banen_l_o_niet_commerciele_dienstverlening")] <- list()

# inkomen
names(data)[names(data) == "Totaal.personen"] <- "inkomen"
names(data)[names(data) == "Mannen.1"] <- "inkomen_mannen"
names(data)[names(data) == "Vrouwen.1"] <- "inkomen_vrouwen"
names(data)[names(data) == "X25.tot.35.jaar"] <- "inkomen_25_35"
names(data)[names(data) == "X35.tot.45.jaar"] <- "inkomen_35_45"
names(data)[names(data) == "X45.tot.55.jaar"] <- "inkomen_45_55"
names(data)[names(data) == "X55.tot.65.jaar"] <- "inkomen_55_65"
names(data)[names(data) == "Autochtonen.1"] <- "inkomen_autochtonen"
names(data)[names(data) == "Westerse.allochtonen.1"] <- "inkomen_westerse_allochtonen"
names(data)[names(data) == "Niet.westerse.allochtonen"] <- "inkomen_niet_westerse_allochtonen"
names(data)[names(data) == "Totaal.particuliere.huishoudens"] <- "inkomen_huishoudens"
names(data)[names(data) == "Totaal.particuliere.huishoudens.1"] <- "inkomen_huishoudens_gestandaardiseerd"
data[c("inkomen", "inkomen_mannen", "inkomen_vrouwen", "inkomen_25_35", "inkomen_35_45", "inkomen_45_55",
    "inkomen_55_65", "inkomen_autochtonen", "inkomen_westerse_allochtonen", "inkomen_niet_westerse_allochtonen",
    "inkomen_huishoudens", "inkomen_huishoudens_gestandaardiseerd")] <- list()

# uitkeringen
names(data)[names(data) == "WW.uitkeringen.totaal..relatief"] <- "uitkeringen_ww"
names(data)[names(data) == "WW.uitkeringen.mannen"] <- "uitkeringen_ww_mannen"
names(data)[names(data) == "WW.uitkeringen.vrouwen"] <- "uitkeringen_ww_vrouwen"
names(data)[names(data) == "ABW.WWB.WIJ.uitkeringen.totaal..relatief"] <- "uitkeringen_abw"
names(data)[names(data) == "ABW.WWB.WIJ.uitkeringen.man.15.tot.65"] <- "uitkeringen_abw_mannen"
names(data)[names(data) == "ABW.WWB.WIJ.uitkeringen.vrouw.15.tot.65"] <- "uitkeringen_abw_vrouwen"
data[c("uitkeringen_ww", "uitkeringen_ww_mannen", "uitkeringen_ww_vrouwen", "uitkeringen_abw",
    "uitkeringen_abw_mannen", "uitkeringen_abw_vrouwen")] <- list()


# ==== BEDRIJVEN ====
names(data)[names(data) == "Totaal.aantal.bedrijfsvestigingen"] <- "bedrijfsvestigingen_totaal"
names(data)[names(data) == "A.Landbouw..bosbouw.en.visserij"] <- "bedrijfsvestigingen_a_landbouw_bosbouw_visserij"
names(data)[names(data) == "B.F.Nijverheid.en.energievoorzieninig"] <- "bedrijfsvestigingen_b_f_nijverheid_energievoorziening"
names(data)[names(data) == "G.N.Commerciële.dienstverlening"] <- "bedrijfsvestigingen_g_n_commerciele_dienstverlening"
names(data)[names(data) == "O.S.Niet.commerciële.dienstverlening"] <- "bedrijfsvestigingen_niet_commerciele_dienstverlening"
data[c("bedrijfsvestigingen_totaal", "bedrijfsvestigingen_a_landbouw_bosbouw_visserij",
    "bedrijfsvestigingen_b_f_nijverheid_energievoorziening", "bedrijfsvestigingen_g_n_commerciele_dienstverlening",
    "bedrijfsvestigingen_niet_commerciele_dienstverlening")] <- list()


# ==== LANDBOUW ====
names(data)[names(data) == "Rundvee"] <- "veestapel_rundvee"
names(data)[names(data) == "Paarden..pony.s..schapen..geiten"] <- "veestapel_paarden_schapen_geiten"
names(data)[names(data) == "Varkens"] <- "veestapel_varkens"
names(data)[names(data) == "Kippen"] <- "veestapel_kippen"
names(data)[names(data) == "Kalkoenen..slachteenden..overig.pluimvee"] <- "veestapel_overig_pluimvee"
names(data)[names(data) == "Konijnen..edelpelsdieren"] <- "veestapel_konijnen_edelpelsdieren"
vars <- c("veestapel_rundvee", "veestapel_paarden_schapen_geiten", "veestapel_varkens",
    "veestapel_kippen", "veestapel_overig_pluimvee", "veestapel_konijnen_edelpelsdieren")
for (var in vars) {
  data[,var] <- as.numeric(as.character(data[,var]))
  data[is.na(data[,var]), var] <- 0
  data[,var] <- data[,var] / data$oppervlakte_land
}

names(data)[names(data) == "Totale.oppervlakte"] <- "landbouw_oppervlakte_totaal"
names(data)[names(data) == "Akkerbouw"] <- "landbouw_oppervlakte_akkerbouw"
names(data)[names(data) == "Tuinbouw.open.grond"] <- "landbouw_oppervlakte_tuinbouw_open"
names(data)[names(data) == "Tuinbouw.onder.glas"] <- "landbouw_oppervlakte_tuinbouw_glas"
names(data)[names(data) == "Blijvend.grasland"] <- "landbouw_oppervlakte_grasland_blijvend"
names(data)[names(data) == "Natuurlijk.grasland"] <- "landbouw_oppervlakte_grasland_natuurlijk"
names(data)[names(data) == "Tijdelijk.grasland"] <- "landbouw_oppervlakte_grasland_tijdelijk"
names(data)[names(data) == "Groenvoedergewassen"] <- "landbouw_oppervlakte_groenvoeder"
data[c("landbouw_oppervlakte_totaal")] <- NULL
vars <- c("landbouw_oppervlakte_akkerbouw", "landbouw_oppervlakte_tuinbouw_open", 
    "landbouw_oppervlakte_tuinbouw_glas", "landbouw_oppervlakte_grasland_blijvend", 
    "landbouw_oppervlakte_grasland_natuurlijk", "landbouw_oppervlakte_grasland_tijdelijk", 
    "landbouw_oppervlakte_groenvoeder")
for (var in vars) {
  data[,var] <- as.numeric(as.character(data[,var]))
  data[is.na(data[,var]), var] <- 0
}


names(data)[names(data) == "Stikstofuitscheiding"] <- "stikstofuitscheiding"
names(data)[names(data) == "Fosfaatuitscheiding"] <- "fosfaatuitscheiding"
names(data)[names(data) == "Kali.uitscheiding"] <- "kaliuitscheiding"
names(data)[names(data) == "Dunne.mest"] <- "dunne_mest"
names(data)[names(data) == "Vaste.mest"] <- "vast_mest"
data[c("stikstofuitscheiding", "fosfaatuitscheiding", "kaliuitscheiding", "dunne_mest", "vast_mest")] <- list()


# ==== VERKEER EN VERVOER ====

names(data)[names(data) == "Personenauto.s"] <- "personenautos"
names(data)[names(data) == "Personenauto.s..relatief"] <- "personenautos_relatief"
names(data)[names(data) == "Personenauto.s.particulieren"] <- "personenautos_particulieren"
names(data)[names(data) == "Personenauto.s.particulieren..relatief"] <- "personenautos_particulieren_relatief"
names(data)[names(data) == "Bedrijfsmotorvoertuigen"] <- "bedrijfsmotorvoertuigen"
names(data)[names(data) == "Motortweewielers"] <- "motortweewielers"
names(data)[names(data) == "Motortweewielers..relatief"] <- "motortweewielers_relatief"
data$personenautos <- data$personenautos/data$oppervlakte_land
data$personenautos_relatief <- data$personenautos_relatief/1000
data$personenautos_particulieren <- NULL
data$personenautos_particulieren_relatief <- NULL
data$bedrijfsmotorvoertuigen <- data$bedrijfsmotorvoertuigen/data$oppervlakte_land
data$bedrijfsmotorvoertuigen_relatief <- data$bedrijfsmotorvoertuigen/data$totale_bevolking


names(data)[names(data) == "Totale.weglengte"] <- "weglengte_totaal"
names(data)[names(data) == "Gemeentelijke.en.waterschapswegen"] <- "weglengte_gemeentelijk_waterschap"
names(data)[names(data) == "Provinciale.wegen"] <- "weglengte_provinciaal"
names(data)[names(data) == "Rijkswegen"] <- "weglengte_rijkswegen"
vars <- c("weglengte_totaal", "weglengte_gemeentelijk_waterschap", "weglengte_provinciaal",
    "weglengte_rijkswegen")
for (var in vars) {
  data[,var] <- as.numeric(as.character(data[,var]))
  data[is.na(data[,var]), var] <- 0
  data[,var] <- data[,var] / data$oppervlakte_land
}


# ==== VOORZIENINGEN ====
names(data)[names(data) == "Afstand.tot.huisartsenpraktijk"] <- "afstand_huisartsenpraktijk"
names(data)[names(data) == "Aantal.huisartsenpraktijken.binnen.3.km"] <- "aantal_huisartsenpraktijken_3km"
names(data)[names(data) == "Afstand.tot.huisartsenpost"] <- "afstand_huisartsenpost"
names(data)[names(data) == "Afstand.tot.ziekenhuis"] <- "afstand_ziekenhuis"
names(data)[names(data) == "Aantal.ziekenhuizen.binnen.20.km"] <- "aantal_ziekenhuizen_20km"
names(data)[names(data) == "Afstand.tot.kinderdagverblijf"] <- "afstand_kinderdagverblijf"
names(data)[names(data) == "Aantal.kinderdagverblijven.binnen.3.km"] <- "aantal_kinderdagverblijven_3km"
names(data)[names(data) == "Afstand.tot.school.basisonderwijs"] <- "afstand_basisonderwijs"
names(data)[names(data) == "Aantal.basisonderwijsscholen.binnen.3.km"] <- "aantal_basisscholen_3km"
names(data)[names(data) == "Afstand.tot.school.vmbo"] <- "afstand_vmbo"
names(data)[names(data) == "Aantal.scholen.vmbo.binnen.5.km"] <- "aantal_vmbo_5km"
names(data)[names(data) == "Afstand.tot.school.havo.vwo"] <- "afstand_have_vwo"
names(data)[names(data) == "Aantal.scholen.havo.vwo.binnen.5.km"] <- "aantal_have_vwo_5km"
names(data)[names(data) == "Afstand.tot.grote.supermarkt"] <- "afstand_grote_supermarkt"
names(data)[names(data) == "Aantal.grote.supermarkten.binnen.3.km"] <- "aantal_grote_supermarkt_3km"
names(data)[names(data) == "Afstand.tot.restaurant"] <- "afstand_restaurant"
names(data)[names(data) == "Aantal.restaurants.binnen.3.km"] <- "aantal_restaurants_3km"
names(data)[names(data) == "Afstand.tot.bibliotheek"] <- "afstand_bibliotheek"
names(data)[names(data) == "Afstand.tot.bioscoop"] <- "afstand_bioscoop"
names(data)[names(data) == "Aantal.bioscopen.binnen.10.km"] <- "aantal_bioscopen_10km"
names(data)[names(data) == "Afstand.tot.zwembad"] <- "afstand_zwembad"
names(data)[names(data) == "Afstand.tot.sportterrein"] <- "afstand_sportterrein"
names(data)[names(data) == "Afstand.tot.openbaar.groen"] <- "afstand_openbaar_groen"
names(data)[names(data) == "Afstand.tot.oprit.hoofdverkeersweg"] <- "afstand_oprit_hoofdverkeersweg"
names(data)[names(data) == "Afstand.tot.treinstation"] <- "afstand_treinstation"
data[c("afstand_huisartsenpost", "afstand_basisonderwijs", "aantal_basisscholen_3km",
    "afstand_bibliotheek", "afstand_sportterrein", "afstand_openbaar_groen")] <- list()

# ==== OVERIG ====
#names(data)[names(data) == "Totaal.huishoudelijk.afval"] <- ""
#names(data)[names(data) == "Huishoudelijk.restafval"] <- ""
#names(data)[names(data) == "Grof.huishoudelijk.restafval"] <- ""
#names(data)[names(data) == "Gft.afval"] <- ""
#names(data)[names(data) == "Oud.papier.en.karton"] <- ""
#names(data)[names(data) == "Verpakkingsglas"] <- ""
#names(data)[names(data) == "Textiel"] <- ""
#names(data)[names(data) == "Klein.chemisch.afval"] <- ""
#names(data)[names(data) == "Overig.huishoudelijk.afval"] <- ""
#names(data)[names(data) == "Totale.oppervlakte.1"] <- ""
#names(data)[names(data) == "Land"] <- ""
#names(data)[names(data) == "Omgevingsadressendichtheid"] <- ""
#names(data)[names(data) == "Verkeersterrein"] <- ""
#names(data)[names(data) == "Bebouwd.terrein"] <- ""
#names(data)[names(data) == "Semi.bebouwd.terrein"] <- ""
#names(data)[names(data) == "Recreatieterrein"] <- ""
#names(data)[names(data) == "Agrarisch.terrein"] <- ""
#names(data)[names(data) == "Bos.en.open.natuurlijk.terrein"] <- ""
#names(data)[names(data) == "Verkeersterrein.1"] <- ""
#names(data)[names(data) == "Bebouwd.terrein.1"] <- ""
#names(data)[names(data) == "Semi.bebouwd.terrein.1"] <- ""
#names(data)[names(data) == "Recreatieterrein.1"] <- ""
#names(data)[names(data) == "Agrarisch.terrein.1"] <- ""
#names(data)[names(data) == "Bos.en.open.natuurlijk.terrein.1"] <- ""
#names(data)[names(data) == "Koppelvariabele.regio..code."] <- ""


# ==== Remove unedited columns ====
data <- data[, grep("^[A-Z]", names(data), invert=TRUE)]

# ==== META ====
longnames <- names(data)
longnames[longnames == "totale_bevolking"] <- "Totale bevolking"
longnames[longnames == "mannen"] <- "Percentage mannen"
longnames[longnames == "vrouwen"] <- "Percentage vrouwen"
longnames[longnames == "ongehuwd"] <- "Percentage ongehuwden"
longnames[longnames == "gehuwd"] <- "Percentage gehuwden"
longnames[longnames == "gescheiden"] <- "Percentage gescheiden personen"
longnames[longnames == "verweduwd"] <- "Percentage verweduwde personen"
longnames[longnames == "autochtoon"] <- "Percentage ongehuwden"
longnames[longnames == "totaal_allochtoon"] <- "Percentage allochtonen"
longnames[longnames == "westers_allochtoon"] <- "Percentage westerse allochtonen"
longnames[longnames == "niet_westers_allochtoon"] <- "Percentage niet-westerse allochtonen"
longnames[longnames == "allochtoon_marokko"] <- "Percentage allochtonen van Marokkaanse afkomst"
longnames[longnames == "allochtoon_antillen_aruba"] <- "Percentage allochtonen van Antilliaanse of Arubaanse afkomst"
longnames[longnames == "allochtoon_suriname"] <- "Percentage allochtonen van Surinaamse afkomst"
longnames[longnames == "allochtoon_turkije"] <- "Percentage allochtonen van Turkse afkomst"
longnames[longnames == "allochtoon_overig_niet_westers"] <- "Percentace allochtonen van overige niet-westerse afkomst"
longnames[longnames == "dichtheid"] <- "Bevolkingsdichtheid"
longnames[longnames == "eenpersoonshuishoudens"] <- "Percentage eenpersoonshuishoudens"
longnames[longnames == "huishoudens_zonder_kinderen"] <- "Percentage huishoudens zonder kinderen"
longnames[longnames == "huishoudens_met_kinderen"] <- "Percentage huishoudens met kinderen"
longnames[longnames == "gemiddelde_huishoudensgrootte"] <- "Gemiddelde huishoudensgrootte"
longnames[longnames == "gemiddelde_woningwaarde"] <- "Gemiddelde woningwaarde"
longnames[longnames == "veestapel_rundvee"] <- "Veestapel rundvee"
longnames[longnames == "veestapel_paarden_schapen_geiten"] <- "Veestapel paarden, schapen en geiten"
longnames[longnames == "veestapel_varkens"] <- "Veestapel varkens"
longnames[longnames == "veestapel_kippen"] <- "Veestapel kippen"
longnames[longnames == "veestapel_overig_pluimvee"] <- "Veestapel overig pluimvee"
longnames[longnames == "veestapel_konijnen_edelpelsdieren"] <- "Veestapel konijnen en edelpelsdieren"
longnames[longnames == "landbouw_oppervlakte_akkerbouw"] <- "Oppervlaktepercentage akkerbouw"
longnames[longnames == "landbouw_oppervlakte_tuinbouw_open"] <- "Oppervlaktepercentage open tuinbouw"
longnames[longnames == "landbouw_oppervlakte_tuinbouw_glas"] <- "Oppervlaktepercentage glastuinbouw"
longnames[longnames == "landbouw_oppervlakte_grasland_blijvend"] <- "Oppervlaktepercentage blijvend grasland"
longnames[longnames == "landbouw_oppervlakte_grasland_natuurlijk"] <- "Oppervlaktepercentage natuurlijk grasland"
longnames[longnames == "landbouw_oppervlakte_grasland_tijdelijk"] <- "Oppervlaktepercentage tijdelijk grasland"
longnames[longnames == "landbouw_oppervlakte_groenvoeder"] <- "Oppervlaktepercentage groenvoeder"
longnames[longnames == "personenautos"] <- "Personenautodichtheid"
longnames[longnames == "personenautos_relatief"] <- "Gemiddelde aantal personenauto's per persoon"
longnames[longnames == "bedrijfsmotorvoertuigen"] <- "Bedrijfsmotorvoertuigendichtheid"
longnames[longnames == "bedrijfsmotorvoertuigen_relatief"] <- "Gemiddelde aantal bedrijfsvoertuigen per persoon"
longnames[longnames == "motortweewielers"] <- "Motortweewielersdichtheid"
longnames[longnames == "motortweewielers_relatief"] <- "Gemiddeld aantal motortweewielers per persoon"
longnames[longnames == "weglengte_totaal"] <- "Weglengte per vierkante kilometer"
longnames[longnames == "weglengte_gemeentelijk_waterschap"] <- "Gemeentelijke en waterschaps weglengte per vierkante kilometer"
longnames[longnames == "weglengte_provinciaal"] <- "Provinciale weglengte per vierkante kilometer"
longnames[longnames == "weglengte_rijkswegen"] <- "Weglengte rijkswegen per vierkante kilometer"
longnames[longnames == "afstand_huisartsenpraktijk"] <- "Gemiddelde afstand dichtsbijzijnde huisartsenpraktijk"
longnames[longnames == "aantal_huisartsenpraktijken_3km"] <- "Gemiddelde aantal huisartsenpraktijken binnen 3 kilometer"
longnames[longnames == "afstand_ziekenhuis"] <- "Gemiddelde afstand dichtsbijzijnde ziekenhuis"
longnames[longnames == "aantal_ziekenhuizen_20km"] <- "Gemiddelde aantal ziekenhuizen binnen 20 kilometer"
longnames[longnames == "afstand_kinderdagverblijf"] <- "Gemiddelde afstand dichtsbijzijnde kinderdagverblijf"
longnames[longnames == "aantal_kinderdagverblijven_3km"] <- "Gemiddelde aantal kinderdagverblijven binnen 3 kilometer"
longnames[longnames == "afstand_vmbo"] <- "Gemiddelde afstand dichtsbijzijnde VMBO"
longnames[longnames == "aantal_vmbo_5km"] <- "Gemiddelde aantal VMBO instellingen binnen 5 kilometer"
longnames[longnames == "afstand_have_vwo"] <- "Gemiddelde afstand dichtsbijzijnde HAVO/VWO"
longnames[longnames == "aantal_have_vwo_5km"] <- "Gemiddelde aantal HAVO/VWO instellingen binnen 5 kilometer"
longnames[longnames == "afstand_grote_supermarkt"] <- "Gemiddelde afstand dichtsbijzijnde grote supermarkt"
longnames[longnames == "aantal_grote_supermarkt_3km"] <- "Gemiddelde aantal grote supermarkten binnen 3 kilometer"
longnames[longnames == "afstand_restaurant"] <- "Gemiddelde afstand dichtsbijzijnde restaurant"
longnames[longnames == "aantal_restaurants_3km"] <- "Gemiddelde aantal restaurants binnen 3 kilometer"
longnames[longnames == "afstand_bioscoop"] <- "Gemiddelde afstand dichtsbijzijnde bioscoop"
longnames[longnames == "aantal_bioscopen_10km"] <- "Gemiddelde aantal bioscopen binnen 10 kilometer"
longnames[longnames == "afstand_zwembad"] <- "Gemiddelde afstand dichtsbijzijnde zwembad"
longnames[longnames == "afstand_oprit_hoofdverkeersweg"] <- "Gemiddelde afstand dichtsbijzijnde oprit hoofdverkeersweg"
longnames[longnames == "afstand_treinstation"] <- "Gemiddelde afstand treinstation"
longnames[longnames == "oppervlakte_totaal"] <- "Totale oppervlakte"
longnames[longnames == "oppervlakte_land"] <- "Totale oppervlakte land"
longnames[longnames == "lft_0_15"] <- "Percentage personen tussen 0 en 15 jaar"
longnames[longnames == "lft_15_65"] <- "Percentage personen tussen 15 en 65 jaar"
longnames[longnames == "lft_65"] <- "Percentage personen 65 jaar of ouder"

units <- names(data)
units[units == "totale_bevolking"] <- "aantal personen"
units[units == "mannen"] <- "% van bevolking"
units[units == "vrouwen"] <- "% van bevolking"
units[units == "ongehuwd"] <- "% van bevolking 15 jaar of ouder"
units[units == "gehuwd"] <- "% van bevolking 15 jaar of ouder"
units[units == "gescheiden"] <- "% van bevolking 15 jaar of ouder"
units[units == "verweduwd"] <- "% van bevolking 15 jaar of ouder"
units[units == "autochtoon"] <- "% van bevolking"
units[units == "totaal_allochtoon"] <- "% van bevolking"
units[units == "westers_allochtoon"] <- "% van bevolking"
units[units == "niet_westers_allochtoon"] <- "% van bevolking"
units[units == "allochtoon_marokko"] <- "% van bevolking"
units[units == "allochtoon_antillen_aruba"] <- "% van bevolking"
units[units == "allochtoon_suriname"] <- "% van bevolking"
units[units == "allochtoon_turkije"] <- "% van bevolking"
units[units == "allochtoon_overig_niet_westers"] <- "% van bevolking"
units[units == "dichtheid"] <- "personen per vierkantekilometer"
units[units == "eenpersoonshuishoudens"] <- "% van huishoudens"
units[units == "huishoudens_zonder_kinderen"] <- "% van huishoudens"
units[units == "huishoudens_met_kinderen"] <- "% van huishoudens"
units[units == "gemiddelde_huishoudensgrootte"] <- "personen per huishouden"
units[units == "gemiddelde_woningwaarde"] <- "keuro"
units[units == "veestapel_rundvee"] <- "dieren per vierkante kilometer"
units[units == "veestapel_paarden_schapen_geiten"] <- "dieren per vierkante kilometer"
units[units == "veestapel_varkens"] <- "dieren per vierkante kilometer"
units[units == "veestapel_kippen"] <- "dieren per vierkante kilometer"
units[units == "veestapel_overig_pluimvee"] <- "dieren per vierkante kilometer"
units[units == "veestapel_konijnen_edelpelsdieren"] <- "dieren per vierkante kilometer"
units[units == "landbouw_oppervlakte_akkerbouw"] <- "% van landbouwareaal"
units[units == "landbouw_oppervlakte_tuinbouw_open"] <- "% van landbouwareaal"
units[units == "landbouw_oppervlakte_tuinbouw_glas"] <- "% van landbouwareaal"
units[units == "landbouw_oppervlakte_grasland_blijvend"] <- "% van landbouwareaal"
units[units == "landbouw_oppervlakte_grasland_natuurlijk"] <- "% van landbouwareaal"
units[units == "landbouw_oppervlakte_grasland_tijdelijk"] <- "% van landbouwareaal"
units[units == "landbouw_oppervlakte_groenvoeder"] <- "% van landbouwareaal"
units[units == "personenautos"] <- "voertuigen per vierkante kilometer"
units[units == "personenautos_relatief"] <- "voertuigen per persoon"
units[units == "bedrijfsmotorvoertuigen"] <- "voertuigen per vierkante kilometer"
units[units == "bedrijfsmotorvoertuigen_relatief"] <- "voertuigen per persoon"
units[units == "motortweewielers"] <- "voertuigen per vierkante kilometer"
units[units == "motortweewielers_relatief"] <- "voertuigen per persoon"
units[units == "weglengte_totaal"] <- "km per vierkante kilometer"
units[units == "weglengte_gemeentelijk_waterschap"] <- "km per vierkante kilometer" 
units[units == "weglengte_provinciaal"] <- "km per vierkante kilometer"
units[units == "weglengte_rijkswegen"] <- "km per vierkante kilometer"
units[units == "afstand_huisartsenpraktijk"] <- "km"
units[units == "aantal_huisartsenpraktijken_3km"] <- "aantal"
units[units == "afstand_ziekenhuis"] <- "km"
units[units == "aantal_ziekenhuizen_20km"] <- "aantal"
units[units == "afstand_kinderdagverblijf"] <- "km"
units[units == "aantal_kinderdagverblijven_3km"] <- "aantal"
units[units == "afstand_vmbo"] <- "km"
units[units == "aantal_vmbo_5km"] <- "aantal"
units[units == "afstand_have_vwo"] <- "km"
units[units == "aantal_have_vwo_5km"] <- "aantal"
units[units == "afstand_grote_supermarkt"] <- "km"
units[units == "aantal_grote_supermarkt_3km"] <- "aantal"
units[units == "afstand_restaurant"] <- "km"
units[units == "aantal_restaurants_3km"] <- "aantal"
units[units == "afstand_bioscoop"] <- "km"
units[units == "aantal_bioscopen_10km"] <- "aantal"
units[units == "afstand_zwembad"] <- "km"
units[units == "afstand_oprit_hoofdverkeersweg"] <- "km"
units[units == "afstand_treinstation"] <- "km"
units[units == "oppervlakte_totaal"] <- "vierkante kilometer"
units[units == "oppervlakte_land"] <- "vierkante kilometer"
units[units == "lft_0_15"] <- "% van bevolking"
units[units == "lft_15_65"] <- "% van bevolking"
units[units == "lft_65"] <- "% van bevolking"


# ==== CONVERT TO JSON ==== 
if (TRUE) {
    code <- which(names(data) == "gemeentecode")
    p1 <- paste(
           paste('"', names(data)[1], '"', sep=""),
           paste('"', data[,1], '"', sep=""),
           sep=":")

    for (i in 2:ncol(data)) {
      p10 <- paste(
             paste('"', names(data)[i], '"', sep=""),
             paste('"', data[,i], '"', sep=""),
             sep=":")
      p1 <- paste(p1, p10, sep=",")

    }
    p2 <- paste("  \"", data[, code], "\":{", p1, "}", sep="", collapse=",\n")


    meta <- character()
    for (i in 1:ncol(data)) {
      if (is.numeric(data[, i])) {
        r <- range(data[,i])
        meta <- c(meta,
            paste("\"", names(data)[i], "\":{",
                "\"name\":\"", longnames[i], "\"",
                ", \"unit\":\"", units[i], "\"",
                ", \"min\":", r[1], 
                ", \"max\":", r[2], 
                "}", sep=''))
      }
    }
    meta <- paste("    ", meta, collapse=",\n")
    meta <- paste("  \"meta\":{\n", meta, "\n  },\n", sep='')


    p3 <- paste("{\n", meta, p2, "\n}", sep='')
    writeLines(p3, "data.json")
}
