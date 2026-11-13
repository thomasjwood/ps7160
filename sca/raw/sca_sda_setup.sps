 /*  SPSS Data Definition File
 /*  Created by ddltox on Nov 13, 2026  (Fri 09:41 AM EST)
 /*  DDL source file: "/sda-public/htdocs/tmpdir/AAWfmYiw.txt".

TITLE "Surveys of Consumers".
COMMENT  DDL indicates that dataset record length (reclen) is 299 columns.

DATA LIST fixed records=1
  FILE="x"  /* Replace 'x' with full path name of your input data file.
 /1           CASEID 1-6             YYYYMM 7-12             YYYYQ 13-17
              YYYY 18-21                ID 22-32            IDPREV 33-43
            DATEPR 44-49           IDPREV2 50-60           DATEPR2 61-66
               SAMPLE 67               METHOD 68           ICS 69-74 (2)
           ICC 75-80 (2)           ICE 81-86 (2)                 PAGO 87
            PAGOR1 88-90            PAGOR2 91-93                PAGO5 94
                 PEXP 95                PEXP5 96               INEXQ1 97
            INEXQ2 98-99            INEX 100-102                RINC 103
                BAGO 104                BEXP 105               BUS12 106
            BUS5 107-108           NEWS1 109-110           NEWS2 111-112
               UNEMP 113                GOVT 114               RATEX 115
               PX1Q1 116           PX1Q2 117-118             PX1 119-121
               PX5Q1 122           PX5Q2 123-124             PX5 125-127
                 DUR 128          DURRN1 129-130          DURRN2 131-132
                 HOM 133          HOMRN1 134-135          HOMRN2 136-137
                SHOM 138         SHOMRN1 139-140         SHOMRN2 141-142
                 CAR 143          CARRN1 144-145          CARRN2 146-147
          INCOME 148-153              INCQFM 154               YTL10 155
               YTL90 156               YTL50 157                YTL5 158
                YTL4 159                YTL3 160         HOMEOWN 161-162
         HOMEAMT 163-169             HOMEQFM 170               HTL10 171
               HTL90 172               HTL50 173                HTL5 174
                HTL4 175                HTL3 176             HOMEVAL 177
            HOMPX1Q1 178    HOMPX1Q2 179-183 (1)      HOMPX1 184-189 (1)
            HOMPX5Q1 190    HOMPX5Q2 191-195 (1)      HOMPX5 196-201 (1)
              INVEST 202          INVAMT 203-210              INVQFM 211
               STL10 212               STL90 213               STL50 214
                STL5 215                STL4 216                STL3 217
             AGE 218-219          BIRTHM 220-221          BIRTHY 222-225
              REGION 226                 SEX 227               MARRY 228
              NUMKID 229              NUMADT 230                EDUC 231
              ECLGRD 232              EHSGRD 233          EGRADE 234-235
       EDUCATION 236-237              POLAFF 238              POLREP 239
              POLDEM 240              POLCRD 241              VEHOWN 242
          VEHNUM 243-244              GASPX1 245          GASPX2 246-248
            GAS5 249-252             GAS1PX1 253         GAS1PX2 254-256
            GAS1 257-260        PINC 261-265 (2)       PINC2 266-270 (2)
        PJOB 271-275 (2)        PSSA 276-280 (2)                PCRY 281
        PSTK 282-286 (2)          WT 287-291 (2)       WT_HH 292-295 (2)
 WT_QUINTMED 296-299 (2)
   .

VARIABLE LABELS
   CASEID    'CASE IDENTIFICATION NUMBER' /
   YYYYMM    'SURVEY YEAR & MONTH' /
   YYYYQ     'SURVEY YEAR & QUARTER' /
   YYYY      'SURVEY YEAR' /
   ID        'INTERVIEW ID' /
   IDPREV    'ID IN PREVIOUS INTERVIEW' /
   DATEPR    'DATA MONTH OF PREVIOUS INTERVIEW' /
   IDPREV2   'ID IN FIRST INTERVIEW FOR 3RD INTERVIEW' /
   DATEPR2   'DATA MONTH OF FIRST INTERVIEW FOR 3RD INTERVIEW' /
   SAMPLE    'SAMPLE TYPE' /
   METHOD    'DATA COLLECTION METHOD' /
   ICS       'INDEX OF CONSUMER SENTIMENT' /
   ICC       'INDEX OF CURRENT ECONOMIC CONDITIONS' /
   ICE       'INDEX OF CONSUMER EXPECTATIONS' /
   PAGO      'PERSONAL FINANCES B/W YEAR AGO' /
   PAGOR1    'REASONS: FINANCES B/W YR AGO (1)' /
   PAGOR2    'REASONS: FINANCES B/W YR AGO (2)' /
   PAGO5     'PERSONAL FINANCES B/W YEAR AGO' /
   PEXP      'PERSONAL FINANCES B/W NEXT YEAR' /
   PEXP5     'PERSONAL FINANCES B/W IN 5YRS' /
   INEXQ1    'FAMILY INCOME U/D NEXT YEAR' /
   INEXQ2    'FAMILY INCOME % U/D NEXT YEAR' /
   INEX      'FAMILY INCOME EXPECTATIONS 1 YEAR RECODED' /
   RINC      'REAL FAMILY INCOME NEXT 1-2 YEARS' /
   BAGO      'ECONOMY BETTER/WORSE YEAR AGO' /
   BEXP      'ECONOMY BETTER/WORSE NEXT YEAR' /
   BUS12     'ECONOMY GOOD/BAD NEXT YEAR' /
   BUS5      'ECONOMY GOOD/BAD NEXT 5 YEARS' /
   NEWS1     'NEWS HEARD OF CHANGES IN BUS COND (1)' /
   NEWS2     'NEWS HEARD OF CHANGES IN BUS COND (2)' /
   UNEMP     'UNEMPLOYMENT MORE/LESS NEXT YEAR' /
   GOVT      'GOVERNMENT ECONOMIC POLICY' /
   RATEX     'INTEREST RATES UP/DOWN NEXT YEAR' /
   PX1Q1     'PRICES UP/DOWN NEXT YEAR' /
   PX1Q2     'PRICES % UP/DOWN NEXT YEAR' /
   PX1       'PRICE EXPECTATIONS 1YR RECODED' /
   PX5Q1     'PRICES UP/DOWN NEXT 5 YEARS' /
   PX5Q2     'PRICES % UP/DOWN NEXT 5 YEARS' /
   PX5       'PRICE EXPECTATIONS 5YR RECODED' /
   DUR       'DURABLES BUYING ATTITUDES' /
   DURRN1    'REASONS: DURABLES BUYING ATTITUDES (1)' /
   DURRN2    'REASONS: DURABLES BUYING ATTITUDES (2)' /
   HOM       'HOME BUYING ATTITUDES' /
   HOMRN1    'REASONS: HOME BUYING ATTITUDES (1)' /
   HOMRN2    'REASONS: HOME BUYING ATTITUDES (2)' /
   SHOM      'G/B SELL HOUSE' /
   SHOMRN1   'WHY G/B SELL HOUSE (1)' /
   SHOMRN2   'WHY G/B SELL HOUSE (2)' /
   CAR       'VEHICLE BUYING ATTITUDES' /
   CARRN1    'REASONS: VEH BUYING ATTITUDES (1)' /
   CARRN2    'REASONS: VEH BUYING ATTITUDES (2)' /
   INCOME    'TOTAL HOUSEHOLD INCOME - CURRENT DOLLARS' /
   INCQFM    'INCOME: OPEN OR BRACKET FORMAT' /
   YTL10     'INCOME BOTTOM 10%' /
   YTL90     'INCOME TOP 10%' /
   YTL50     'INCOME ABOVE/BELOW MEDIAN' /
   YTL5      'INCOME QUINTILES' /
   YTL4      'INCOME QUARTILES' /
   YTL3      'INCOME TERCILES' /
   HOMEOWN   'HOME OWNERSHIP' /
   HOMEAMT   'MARKET VALUE OF HOME' /
   HOMEQFM   'MARKET VALUE OF HOME: OPEN OR BRACKET FORMAT' /
   HTL10     'HOME VALUE BOTTOM 10%' /
   HTL90     'HOME VALUE TOP 10%' /
   HTL50     'HOME VALUE ABOVE/BELOW MEDIAN' /
   HTL5      'HOME VALUE QUINTILES' /
   HTL4      'HOME VALUE QUARTILES' /
   HTL3      'HOME VALUE TERCILES' /
   HOMEVAL   'HOME VALUE UP/DOWN' /
   HOMPX1Q1  'HOME VALUE UP/DOWN NEXT YEAR' /
   HOMPX1Q2  'HOME VALUE % UP/DOWN NEXT YEAR' /
   HOMPX1    'HOME PRICE EXPECTATIONS 1YR RECODED' /
   HOMPX5Q1  'HOME PRICES UP/DOWN NEXT 5 YEARS' /
   HOMPX5Q2  'HOME PRICES % UP/DOWN NEXT 5 YEARS' /
   HOMPX5    'HOME PRICE EXPECTATIONS 5YR RECODED' /
   INVEST    'HAVE STOCKS' /
   INVAMT    'INVESTMENT VALUE' /
   INVQFM    'STOCKS VALUE: OPEN OR BRACKET FORMAT' /
   STL10     'STOCK INVESTMENT AMOUNT BOTTOM 10%' /
   STL90     'STOCK INVESTMENT AMOUNT TOP 10%' /
   STL50     'STOCK INVESTMENT AMOUNT ABOVE/BELOW MEDIAN' /
   STL5      'STOCK INVESTMENT AMOUNT QUINTILES' /
   STL4      'STOCK INVESTMENT AMOUNT QUARTILES' /
   STL3      'STOCK INVESTMENT AMOUNT TERCILES' /
   AGE       'AGE OF RESPONDENT' /
   BIRTHM    'MONTH OF BIRTH' /
   BIRTHY    'YEAR OF BIRTH' /
   REGION    'REGION OF RESIDENCE' /
   SEX       'SEX OF RESPONDENT' /
   MARRY     'MARITAL STATUS OF RESPONDENT' /
   NUMKID    'NUMBER OF CHILDREN <18 IN HOUSEHOLD' /
   NUMADT    'NUMBER OF ADULTS 18+ IN HOUSEHOLD' /
   EDUC      'EDUCATION OF RESPONDENT' /
   ECLGRD    'EDUCATION: COLLEGE GRADUATE' /
   EHSGRD    'EDUCATION: HIGH SCHOOL GRADUATE' /
   EGRADE    'EDUCATION: HIGHEST GRADE COMPLETED (ONLY FOR METHOD=1,3)' /
   EDUCATION 'EDUCATION: HIGHEST GRADE COMPLETED' /
   POLAFF    'POLITICAL AFFILIATION' /
   POLREP    'STRONG OR NOT SO STRONG REPUBLICAN' /
   POLDEM    'STRONG OR NOT SO STRONG DEMOCRAT' /
   POLCRD    'CLOSER TO REPUBLICAN OR DEMOCRAT' /
   VEHOWN    'OWN/LEASE VEHICLE' /
   VEHNUM    'NUMBER OF VEHICLES OWNED/LEASED' /
   GASPX1    'GAS PRICES UP/DOWN NEXT 5 YEARS' /
   GASPX2    'PERCENT GAS PRICES UP/DOWN 5 YR' /
   GAS5      'GAS PRICE EXPECTATIONS 5 YR RECODED' /
   GAS1PX1   'GAS PRICES UP/DOWN NEXT 12 MONTHS' /
   GAS1PX2   'PERCENT GAS PRICES UP/DOWN 12 MO' /
   GAS1      'GAS PRICE EXPECTATIONS 12 MO RECODED' /
   PINC      'CHANCE OF Y INCREASE IN 5 YEARS' /
   PINC2     'PERCENT CHANCE OF INCOME INCREASE' /
   PJOB      'CHANCE WILL LOSE JOB IN 5 YEARS' /
   PSSA      'CHANCE WILL HAVE SOCIAL SECURITY' /
   PCRY      'CHANCE WILL HAVE COMFORTABLE RETIREMENT' /
   PSTK      'PERCENT CHANCE OF INVEST INCREASE 1 YEAR' /
   WT        'HOUSEHOLD HEAD WEIGHT USED FOR ESTIMATION (MEAN=1)' /
   WT_HH     'HOUSEHOLD HEAD WEIGHT FOR ALL METHODS (MEAN=1)' /
   WT_QUINTMED 'HOUSEHOLD HEAD WEIGHT FOR ONLY METHOD=2 (MEAN=1)' /
   .

VALUE LABELS
   SAMPLE    1 'Landline RDD Interview' 2 'Landline RDD Reinterview' 
             3 'Cell RDD Interview' 4 'Cell RDD Reinterview' 
             5 'Cell RDD Second Reinterview' 6 'Fresh ABS Web Interview' 
             7 'First ABS Web Reinterview' 8 'Second ABS Web Reinterview' /
   METHOD    1 'Telephone (CATI)' 2 'Web' 3 'Telephone (paper and pencil)' 
             4 'In-person' /
   PAGO      1 'Better now' 3 'Same' 5 'Worse now' 8 'DK' 9 'NA' /
   PAGOR1    0 'No change and no pro-con reason given' 10 'FAV Better pay' 
             11 'FAV Higher income from self-employment or property' 
             12 'FAV More work, hence more income' 
             13 'FAV Increased contributions from outside FU' 
             14 'FAV Lower prices' 
             15 'FAV Lower taxes; low or unchanged taxes' 
             16 'FAV Decreased expenses' 
             18 'FAV Higher interest rates; tight credit' 
             19 'FAV Better asset position' 
             20 'FAV Debt, interest or debt payments low or lower' 
          21 'FAV Change in family composition - higher income or better off' 
             23 'FAV Good times, no recession (not codeable above)' 
             27 'FAV Other reasons for making FU better off' 
             38 'FAV Reference to government economic policy' 
             39 'FAV Income tax refund' 50 'UNFAV Lower pay' 
             51 'UNFAV Lower income from self-employment or property' 
             52 'UNFAV Less work, hence less income' 
             53 'UNFAV Decreased/Unchanged contributions from outside FU' 
             54 'UNFAV High(er) prices' 
             55 'UNFAV Higher interest rates; tight credit' 
             56 'UNFAV High, higher taxes (except 57)' 
             57 'UNFAV Income taxes' 
             58 'UNFAV Increased expenses; more people to be supported by FU' 
             59 'UNFAV Worse asset position' 60 'UNFAV Debt' 
          61 'UNFAV Change in family composition - lower income or worse off' 
             63 'UNFAV Bad times, recession (not codeable above)' 
             64 'UNFAV Strike(s)-- not codeable in 52' 
             67 'UNFAV Other reasons for making FU worse off' 
             78 'UNFAV Reference to government economic policy' 98 'DK' 
             99 'NA' 333 'No change and no pro-con reason given (Web only)' /
   PAGOR2    0 'No second mention' 10 'FAV Better pay' 
             11 'FAV Higher income from self-employment or property' 
             12 'FAV More work, hence more income' 
             13 'FAV Increased contributions from outside FU' 
             14 'FAV Lower prices' 
             15 'FAV Lower taxes; low or unchanged taxes' 
             16 'FAV Decreased expenses' 
             18 'FAV Higher interest rates; tight credit' 
             19 'FAV Better asset position' 
             20 'FAV Debt, interest or debt payments low or lower' 
          21 'FAV Change in family composition - higher income or better off' 
             23 'FAV Good times, no recession (not codeable above)' 
             27 'FAV Other reasons for making FU better off' 
             38 'FAV Reference to government economic policy' 
             39 'FAV Income tax refund' 50 'UNFAV Lower pay' 
             51 'UNFAV Lower income from self-employment or property' 
             52 'UNFAV Less work, hence less income' 
             53 'UNFAV Decreased/Unchanged contributions from outside FU' 
             54 'UNFAV High(er) prices' 
             55 'UNFAV Higher interest rates; tight credit' 
             56 'UNFAV High, higher taxes (except 57)' 
             57 'UNFAV Income taxes' 
             58 'UNFAV Increased expenses; more people to be supported by FU' 
             59 'UNFAV Worse asset position' 60 'UNFAV Debt' 
          61 'UNFAV Change in family composition - lower income or worse off' 
             63 'UNFAV Bad times, recession (not codeable above)' 
             64 'UNFAV Strike(s)-- not codeable in 52' 
             67 'UNFAV Other reasons for making FU worse off' 
             78 'UNFAV Reference to government economic policy' 98 'DK' 
             99 'NA' 333 'No change and no pro-con reason given (Web only)' /
   PAGO5     1 'Better now' 3 'Same' 5 'Worse now' 8 'DK' 9 'NA' /
   PEXP      1 'Will be better off' 3 'Same' 5 'Will be worse off' 8 'DK' 
             9 'NA' /
   PEXP5     1 'Will be better off' 3 'Same' 5 'Will be worse off' 8 'DK' 
             9 'NA' /
   INEXQ1    1 'Higher' 2 'Higher at same rate as now' 3 'About the same' 
             5 'Lower' 8 'DK' 9 'NA' /
   INEXQ2    95 '95% or more' 98 'DK' 99 'NA' /
   INEX      -97 'DK how much down' 96 'DK how much up' 
             98 'DK whether up or down' 99 'NA' /
   RINC      1 'Income up more than prices' 3 'Income up same as prices' 
             5 'Income up less than prices' 8 'DK' 9 'NA' /
   BAGO      1 'Better now' 3 'About the same' 5 'Worse now' 8 'DK' 9 'NA' /
   BEXP      1 'Better a year from now' 3 'About the same' 
             5 'Worse a year from now' 8 'DK' 9 'NA' /
   BUS12     1 'Good times' 2 'Good with qualifications' 3 'Pro-con' 
             4 'Bad with qualifications' 5 'Bad times' 8 'DK' 9 'NA' /
   BUS5      1 'Good times' 2 'Good with qualifications' 3 'Pro-con' 
             4 'Bad with qualifications' 5 'Bad times' 98 'DK' 99 'NA' /
   NEWS1     0 'Has heard of no changes' 
             10 'FAV Elections, admin, Congress, President' 
             11 'FAV More military spending, more war/tensions (fav)' 
             12 'FAV Less military spending, few tensions' 
             13 'FAV Gov''t programs improved' 
             14 'FAV Specific gov''t programs incr/cont' 
             15 'FAV Specific gov''t programs decr/end' 
             16 'FAV Taxes, changes/reforms, rebates' 
             17 'FAV Other references to gov''t' 
             18 'FAV Fiscal policy, budgets, deficits' 
             19 'FAV Gov''t improving business condition' 
             20 'FAV Opening of plants, factories, stores' 
             21 'FAV Consumer/auto demand high' 
             22 'FAV Purch power high, wages high' 
             23 'FAV Employ is high, plenty of jobs' 
             24 'FAV Population increase, more people to buy' 
             25 'FAV Low debts, higher savings/assets, invest up' 
             27 'FAV Other references to employ and purch power' 
             28 'FAV Production increasing, GNP is up' 
             29 'FAV Unemp has risen, good for economy' 
             30 'FAV Tight money, int rates high' 
             31 'FAV Lower/stable prices, less inflation' 
             32 'FAV Higher prices, inflation is good' 
             33 'FAV Easier money, credit easy to get, low int rates' 
             34 'FAV Crowd funding' 35 'FAV Profits high/rising' 
             36 'FAV Stock market, rise in price of stocks' 
             37 'FAV Other references to prices/credit' 
             38 'FAV Balance of payments, dollar devalue' 
             39 'FAV Controls (price or wage)' 
             40 'FAV Better race relations, less crime' 
             41 'FAV Union disputes settled, relations good' 
             42 'FAV Times/business is good in the coming year' 
             43 'FAV Bad times can''t last, due for good times' 
             44 'FAV R sees sign of improvement already' 
             45 'FAV Improvements in specific industries' 
             46 'FAV Farm situation good, crops good' 
             47 'FAV Other good factors or favorable ref' 
             48 'FAV Economy more stable, optimism' 
             49 'FAV Energy crisis, pollution' 
             50 'UNFAV Election, new admin/President' 
             51 'UNFAV More military spending, more war/tensions' 
             52 'UNFAV Less military spending, few tensions' 
             53 'UNFAV Specific gov''t spend programs changed' 
             54 'UNFAV Specific gov''t spend programs eliminated' 
             55 'UNFAV Gov''t progams begun/increased' 
             56 'UNFAV Taxes, changes/reforms, rebates' 
             57 'UNFAV Other references to gov''t' 
             58 'UNFAV Fiscal policy, budgets, deficits' 
             59 'UNFAV Gov''t not improving business conditions' 
             60 'UNFAV Closing of plants, factories, stores' 
             61 'UNFAV Consumer/auto demand low' 
             62 'UNFAV Lack of purch power, no money to spend' 
             63 'UNFAV Drop in employ, less overtime' 
             64 'UNFAV Population increase, immigration' 
             65 'UNFAV High(er) debts, lower savings/assets' 
             67 'UNFAV Other references to employ/purch power' 
             68 'UNFAV Production decreasing, GNP down' 
    69 'UNFAV Real estate/housing market in decline; slumping housing market' 
  70 'UNFAV Financial crisis; financial institutions closing/having problems' 
             71 'UNFAV Prices falling, deflation' 
             72 'UNFAV Prices high, inflation' 
             73 'UNFAV Tight money, int rates high' 
             74 'UNFAV Profits low, falling' 
             75 'UNFAV Profits high, too high' 
             76 'UNFAV Stock market decline' 
             77 'UNFAV Other price/credit references' 
             78 'UNFAV Balance of payments, dollar devalue' 
             79 'UNFAV Controls (price or wage)' 
             80 'UNFAV Bad race relations; more crime' 
             81 'UNFAV Excessive wage demands by unions; labor unrest' 
             82 'UNFAV Times are bad now and won''t change in next year' 
             83 'UNFAV Good times can''t last, due for a fall' 
             84 'UNFAV R sees downward trends, has heard business is bad' 
             85 'UNFAV Decline in specific industries' 
             86 'UNFAV Farm situation is bad, low farm prices, drought' 
             87 'UNFAV Other unfavorable/bad factors' 
             88 'UNFAV Economy in general less stable, lack of confidence' 
             89 'UNFAV Energy crisis, pollution, less natural resources' 
             90 'UNFAV Business/Accounting scandals' 
             97 'Change mentioned but NA whether favorable/unfavorable' 
             98 'DK' 99 'NA' /
   NEWS2     0 'Has heard of no changes, no second mention' 
             10 'FAV Elections, admin, Congress, President' 
             11 'FAV More military spending, more war/tensions (fav)' 
             12 'FAV Less military spending, few tensions' 
             13 'FAV Gov''t programs improved' 
             14 'FAV Specific gov''t programs incr/cont' 
             15 'FAV Specific gov''t programs decr/end' 
             16 'FAV Taxes, changes/reforms, rebates' 
             17 'FAV Other references to gov''t' 
             18 'FAV Fiscal policy, budgets, deficits' 
             19 'FAV Gov''t improving business condition' 
             20 'FAV Opening of plants, factories, stores' 
             21 'FAV Consumer/auto demand high' 
             22 'FAV Purch power high, wages high' 
             23 'FAV Employ is high, plenty of jobs' 
             24 'FAV Population increase, more people to buy' 
             25 'FAV Low debts, higher savings/assets, invest up' 
             27 'FAV Other references to employ and purch power' 
             28 'FAV Production increasing, GNP is up' 
             29 'FAV Unemp has risen, good for economy' 
             30 'FAV Tight money, int rates high' 
             31 'FAV Lower/stable prices, less inflation' 
             32 'FAV Higher prices, inflation is good' 
             33 'FAV Easier money, credit easy to get, low int rates' 
             34 'FAV Crowd funding' 35 'FAV Profits high/rising' 
             36 'FAV Stock market, rise in price of stocks' 
             37 'FAV Other references to prices/credit' 
             38 'FAV Balance of payments, dollar devalue' 
             39 'FAV Controls (price or wage)' 
             40 'FAV Better race relations, less crime' 
             41 'FAV Union disputes settled, relations good' 
             42 'FAV Times/business is good in the coming year' 
             43 'FAV Bad times can''t last, due for good times' 
             44 'FAV R sees sign of improvement already' 
             45 'FAV Improvements in specific industries' 
             46 'FAV Farm situation good, crops good' 
             47 'FAV Other good factors or favorable ref' 
             48 'FAV Economy more stable, optimism' 
             49 'FAV Energy crisis, pollution' 
             50 'UNFAV Election, new admin/President' 
             51 'UNFAV More military spending, more war/tensions' 
             52 'UNFAV Less military spending, few tensions' 
             53 'UNFAV Specific gov''t spend programs changed' 
             54 'UNFAV Specific gov''t spend programs eliminated' 
             55 'UNFAV Gov''t progams begun/increased' 
             56 'UNFAV Taxes, changes/reforms, rebates' 
             57 'UNFAV Other references to gov''t' 
             58 'UNFAV Fiscal policy, budgets, deficits' 
             59 'UNFAV Gov''t not improving business conditions' 
             60 'UNFAV Closing of plants, factories, stores' 
             61 'UNFAV Consumer/auto demand low' 
             62 'UNFAV Lack of purch power, no money to spend' 
             63 'UNFAV Drop in employ, less overtime' 
             64 'UNFAV Population increase, immigration' 
             65 'UNFAV High(er) debts, lower savings/assets' 
             67 'UNFAV Other references to employ/purch power' 
             68 'UNFAV Production decreasing, GNP down' 
    69 'UNFAV Real estate/housing market in decline; slumping housing market' 
  70 'UNFAV Financial crisis; financial institutions closing/having problems' 
             71 'UNFAV Prices falling, deflation' 
             72 'UNFAV Prices high, inflation' 
             73 'UNFAV Tight money, int rates high' 
             74 'UNFAV Profits low, falling' 
             75 'UNFAV Profits high, too high' 
             76 'UNFAV Stock market decline' 
             77 'UNFAV Other price/credit references' 
             78 'UNFAV Balance of payments, dollar devalue''' 
             79 'UNFAV Controls (price or wage)' 
             80 'UNFAV Bad race relations; more crime' 
             81 'UNFAV Excessive wage demands by unions; labor unrest' 
             82 'UNFAV Times are bad now and won''t change in next year' 
             83 'UNFAV Good times can''t last, due for a fall' 
             84 'UNFAV R sees downward trends, has heard business is bad' 
             85 'UNFAV Decline in specific industries' 
             86 'UNFAV Farm situation is bad, low farm prices, drought' 
             87 'UNFAV Other unfavorable/bad factors' 
             88 'UNFAV Economy in general less stable, lack of confidence' 
             89 'UNFAV Energy crisis, pollution, less natural resources' 
             90 'UNFAV Business/Accounting scandals' 
             97 'Change mentioned but NA whether favorable/unfavorable' 
             98 'DK' 99 'NA' /
   UNEMP     1 'More unemployment' 3 'About the same' 5 'Less unemployment' 
             8 'DK' 9 'NA' /
   GOVT      1 'Good job' 3 'Only fair' 5 'Poor job' 8 'DK' 9 'NA' /
   RATEX     1 'Go up' 3 'Stay the same' 5 'Go down' 8 'DK' 9 'NA' /
   PX1Q1     1 'Go up' 2 'Go up (at same rate)' 3 'Same' 5 'Go down' 8 'DK' 
             9 'NA' /
   PX1Q2     95 '95% or more' 98 'DK' 99 'NA' /
   PX1       -97 'DK how much down' 96 'DK how much up' 
             98 'DK whether up or down' 99 'NA' /
   PX5Q1     1 'Go up' 2 'Go up (at same rate)' 3 'Same' 5 'Go down' 8 'DK' 
             9 'NA' /
   PX5Q2     95 '95% or more' 98 'DK' 99 'NA' /
   PX5       -97 'DK how much down' 96 'DK how much up' 
             98 'DK whether up or down' 99 'NA' /
   DUR       1 'Good' 3 'Pro-con' 5 'Bad' 8 'DK' 9 'NA' /
   DURRN1    0 'No second mention' 
             10 'FAV Interest rates won''t get any lower' 
             11 'FAV Prices are low(er), prices reasonably stable' 
             12 'FAV Good buys available, sales, discounts' 
             13 'FAV Prices are going up, future uncertainty' 
             14 'FAV Prices won''t get any lower' 15 'FAV Lower down payment' 
             16 'FAV Interest rates low' 
             17 'FAV Credit easy to get, easy money' 
             18 'FAV Interest rates are going up, credit tighter' 
             19 'FAV Low taxes, tax changes' 
             21 'FAV People can afford to buy now, have money to spend' 
             23 'FAV Buying makes for good times, prosperity' 
             31 'FAV Supply adequate, no shortages now' 
             32 'FAV Quality is good/better/may get worse' 
             33 'FAV New models have improvements/new features' 
             34 'FAV Good selection, variety' 
             41 'FAV Seasonal references only' 
             42 'FAV R says if you need it, good time as any' 
             43 'FAV Low sales won''t last, will pick up soon' 
             47 'FAV Other good reasons' 
             49 'FAV Economic policy, references to gov''t/president' 
             50 'UNFAV Interest rates won''t get any lower' 
             51 'UNFAV Prices are too high, prices going up' 
             52 'UNFAV Seller''s market, few sales or discounts' 
             53 'UNFAV Prices will fall later, will come down' 
             54 'UNFAV Debt or credit is bad' 
             55 'UNFAV Larger/higher down payment required' 
             56 'UNFAV Interest rates high/going up' 
             57 'UNFAV Credit/financing hard to get; tight money' 
             58 'UNFAV Interest rates will fall later' 
             59 'UNFAV Taxes high, going higher' 
             61 'UNFAV People can''t afford to buy now' 
             62 'UNFAV People should save money' 
             63 'UNFAV Buying contributes to inflation, makes for bad times' 
             65 'UNFAV Energy crisis; shortages of fuels' 
             71 'UNFAV Supply inadequate, poor selection' 
             72 'UNFAV Quality is poor, may improve later' 
             73 'UNFAV Poor designs; unattractive styling' 
             81 'UNFAV R mentions only seasonal factors' 
             82 'UNFAV International references' 
             87 'UNFAV Other reasons why now is a bad time to buy' 
             89 'UNFAV Economic policy, references to gov''t/president' 
             98 'DK' 99 'NA' /
   DURRN2    0 'No second mention' 
             10 'FAV Interest rates won''t get any lower' 
             11 'FAV Prices are low(er), prices reasonably stable' 
             12 'FAV Good buys available, sales, discounts' 
             13 'FAV Prices are going up, future uncertainty' 
             14 'FAV Prices won''t get any lower' 15 'FAV Lower down payment' 
             16 'FAV Interest rates low' 
             17 'FAV Credit easy to get, easy money' 
             18 'FAV Interest rates are going up, credit tighter' 
             19 'FAV Low taxes, tax changes' 
             21 'FAV People can afford to buy now, have money to spend' 
             23 'FAV Buying makes for good times, prosperity' 
             31 'FAV Supply adequate, no shortages now' 
             32 'FAV Quality is good/better/may get worse' 
             33 'FAV New models have improvements/new features' 
             34 'FAV Good selection, variety' 
             41 'FAV Seasonal references only' 
             42 'FAV R says if you need it, good time as any' 
             43 'FAV Low sales won''t last, will pick up soon' 
             47 'FAV Other good reasons' 
             49 'FAV Economic policy, references to gov''t/president' 
             50 'UNFAV Interest rates won''t get any lower' 
             51 'UNFAV Prices are too high, prices going up' 
             52 'UNFAV Seller''s market, few sales or discounts' 
             53 'UNFAV Prices will fall later, will come down' 
             54 'UNFAV Debt or credit is bad' 
             55 'UNFAV Larger/higher down payment required' 
             56 'UNFAV Interest rates high/going up' 
             57 'UNFAV Credit/financing hard to get; tight money' 
             58 'UNFAV Interest rates will fall later' 
             59 'UNFAV Taxes high, going higher' 
             61 'UNFAV People can''t afford to buy now' 
             62 'UNFAV People should save money' 
             63 'UNFAV Buying contributes to inflation, makes for bad times' 
             65 'UNFAV Energy crisis; shortages of fuels' 
             71 'UNFAV Supply inadequate, poor selection' 
             72 'UNFAV Quality is poor, may improve later' 
             73 'UNFAV Poor designs; unattractive styling' 
             81 'UNFAV R mentions only seasonal factors' 
             82 'UNFAV International references' 
             87 'UNFAV Other reasons why now is a bad time to buy' 
             89 'UNFAV Economic policy, references to gov''t/president' 
             98 'DK' 99 'NA' /
   HOM       1 'Good' 3 'Pro-con' 5 'Bad' 8 'DK' 9 'NA' /
   HOMRN1    0 'No second mention' 
             10 'FAV Interest rate won''t get any lower' 
             11 'FAV Prices are low/stable/not too high' 
             12 'FAV Good buys available' 13 'FAV Prices are going up' 
             14 'FAV Prices won''t get any lower' 15 'FAV Lower down payment' 
             16 'FAV Interest rates are low' 
             17 'FAV Credit easy to get, easy money' 
             18 'FAV Credit will be tighter later' 
             19 'FAV Lower taxes, taxes higher later' 
             21 'FAV People can afford to buy now' 
             23 'FAV Buying makes for good times, prosperity' 
             27 'FAV Other references to employment and purchasing power' 
             31 'FAV Supply adequate, no shortages now' 
             32 'FAV Quality is good, better, may get worse' 
             33 'FAV New models have improvements, new features' 
             34 'FAV Good selection, variety' 
             41 'FAV Seasonal references only' 
             42 'FAV R only says: if you need it this is a good time' 
             43 'FAV Low sales won''t last, will pick up soon' 
             44 'FAV Renting is unfavorable b/c high rents, shortage' 
             45 'FAV Owning is always a good idea, renting is a bad idea' 
             46 'FAV Capital appreciation: buying is a good investment' 
             47 'FAV Other good reasons (misc.)' 
             48 'FAV Variable mortgage rate' 
             49 'FAV Economic policy, references to gov''t/president' 
             50 'UNFAV Interest rates won''t get any lower' 
             51 'UNFAV Prices are too high, houses cost too much' 
             52 'UNFAV Seller''s market, few sales or discounts' 
             53 'UNFAV Prices will fall later, will come down' 
             54 'UNFAV Debt or credit bad (NA why)' 
             55 'UNFAV Higher/larger down payment required' 
             56 'UNFAV Interest rate too high, will go up' 
             57 'UNFAV Credit hard to get, financing difficult' 
             58 'UNFAV Interest rates will come down later' 
             59 'UNFAV Tax increase, property taxes too high' 
             61 'UNFAV People can''t afford to buy now, times are bad' 
             62 'UNFAV People should save money, uncertain of future' 
             63 'UNFAV Buying contributes to inflation/makes bad times' 
             65 'UNFAV Energy crisis, shortage of fuels' 
             71 'UNFAV Supply inadequate, few houses on market' 
             72 'UNFAV Quality is poor, quality may improve' 
             73 'UNFAV Poor designs, unattractive styling' 
             81 'UNFAV R mentions only seasonal factors' 
             82 'UNFAV Difficult to get rid of present house' 
             83 'UNFAV Better return on alternative investments' 
             84 'UNFAV Renting favorable b/c of low rents' 
             85 'UNFAV Renting is always better than owning' 
             86 'UNFAV Capital depreciation, buying is bad investment' 
             87 'UNFAV Other reasons why now is a bad time to buy' 
             88 'UNFAV Variable mortgage rate' 
             89 'UNFAV Economic policy, references to gov''t/president' 
             90 'Cost of (homeowners) insurance' 98 'DK' 99 'NA' /
   HOMRN2    0 'No second mention' 
             10 'FAV Interest rate won''t get any lower' 
             11 'FAV Prices are low/stable/not too high' 
             12 'FAV Good buys available' 13 'FAV Prices are going up' 
             14 'FAV Prices won''t get any lower' 15 'FAV Lower down payment' 
             16 'FAV Interest rates are low' 
             17 'FAV Credit easy to get, easy money' 
             18 'FAV Credit will be tighter later' 
             19 'FAV Lower taxes, taxes higher later' 
             21 'FAV People can afford to buy now' 
             23 'FAV Buying makes for good times, prosperity' 
             27 'FAV Other references to employment and purchasing power' 
             31 'FAV Supply adequate, no shortages now' 
             32 'FAV Quality is good, better, may get worse' 
             33 'FAV New models have improvements, new features' 
             34 'FAV Good selection, variety' 
             41 'FAV Seasonal references only' 
             42 'FAV R only says: if you need it this is a good time' 
             43 'FAV Low sales won''t last, will pick up soon' 
             44 'FAV Renting is unfavorable b/c high rents, shortage' 
             45 'FAV Owning is always a good idea, renting is a bad idea' 
             46 'FAV Capital appreciation: buying is a good investment' 
             47 'FAV Other good reasons (misc.)' 
             48 'FAV Variable mortgage rate' 
             49 'FAV Economic policy, references to gov''t/president' 
             50 'UNFAV Interest rates won''t get any lower' 
             51 'UNFAV Prices are too high, houses cost too much' 
             52 'UNFAV Seller''s market, few sales or discounts' 
             53 'UNFAV Prices will fall later, will come down' 
             54 'UNFAV Debt or credit bad (NA why)' 
             55 'UNFAV Higher/larger down payment required' 
             56 'UNFAV Interest rate too high, will go up' 
             57 'UNFAV Credit hard to get, financing difficult' 
             58 'UNFAV Interest rates will come down later' 
             59 'UNFAV Tax increase, property taxes too high' 
             61 'UNFAV People can''t afford to buy now, times are bad' 
             62 'UNFAV People should save money, uncertain of future' 
             63 'UNFAV Buying contributes to inflation/makes bad times' 
             65 'UNFAV Energy crisis, shortage of fuels' 
             71 'UNFAV Supply inadequate, few houses on market' 
             72 'UNFAV Quality is poor, quality may improve' 
             73 'UNFAV Poor designs, unattractive styling' 
             81 'UNFAV R mentions only seasonal factors' 
             82 'UNFAV Difficult to get rid of present house' 
             83 'UNFAV Better return on alternative investments' 
             84 'UNFAV Renting favorable b/c of low rents' 
             85 'UNFAV Renting is always better than owning' 
             86 'UNFAV Capital depreciation, buying is bad investment' 
             87 'UNFAV Other reasons why now is a bad time to buy' 
             88 'UNFAV Variable mortgage rate' 
             89 'UNFAV Economic policy, references to gov''t/president' 
             90 'Cost of (homeowners) insurance' 98 'DK' 99 'NA' /
   SHOM      1 'GOOD' 3 'PRO-CON' 5 'BAD' 8 'DK' 9 'NA' /
   SHOMRN1   0 'No second mention' 
         10 'FAV Interest rate won''t get any lower (not codeable elsewhere)' 
             11 'FAV Prices are high/higher/won''t get any lower' 
             12 'FAV Seller''s market (under-supply of houses)' 
             13 'FAV Prices going down; sell before prices lower' 
             14 'FAV Prices won''t get any higher (not codeable 13)' 
             15 'FAV Lower down payment' 
             16 'FAV Interest rates are low (now)' 
             17 'FAV Credit easy to get; easy money, NA if 15, 16, 17, or 18' 
             18 'FAV Credit will be tighter later; interest rates will go up' 
             19 'FAV Lower taxes; taxes will be higher later' 
             21 'FAV People can afford to buy now' 
             23 'FAV Buying makes for good times/prosperity/high employment' 
            31 'FAV Supply inadequate, shortages now; may be shortages later' 
          33 'FAV Good time for existing homes, costs more to build new ones' 
             41 'FAV Seasonal references only' 
           42 'FAV R only says: If need to sell/need money this is good time' 
             44 'FAV Can use cash/capital for other investments' 
             45 'FAV Better to sell now, value of home may decline' 
   46 'FAV Capital appreciation: value of houses increased; good profits now' 
             47 'FAV Other good reasons (miscellaneous)' 
             48 'FAV Variable mortgage rate' 
             49 'FAV Economic policy; references to gov''t/new president' 
      50 'UNFAV Interest rates won''t get any lower (not codeable elsewhere)' 
             51 'UNFAV Prices are low/lower' 
             52 'UNFAV Buyer''s market; difficult to find buyers;' 
           53 'UNFAV Prices will rise later; future uncertainty about prices' 
             54 'UNFAV Interest rates low/lower' 
             55 'UNFAV Higher/Larger down payment required' 
             56 'UNFAV Interest rate too high; will go up' 
   57 'UNFAV Credit hard to get; financing difficult; pt system; tight money' 
          58 'UNFAV Interest rates will come down later; credit easier later' 
             59 'UNFAV Tax increase; (property) taxes too high; going higher' 
             61 'UNFAV People can''t afford to buy now; recession; inflation' 
       62 'UNFAV People should save money; future uncertain; bad times ahead' 
             63 'UNFAV Buying contributes to inflation/makes for bad times' 
        65 'UNFAV Energy crisis; shortages of fuels; high price of utilities' 
      71 'UNFAV Supply adequate; (no reference to influence on prices/deals)' 
             73 'UNFAV Bad time for older homes; people want newer homes' 
             81 'UNFAV R mentions only seasonal factors' 
             84 'UNFAV Home is good\better investment' 
             85 'UNFAV Rents are too high' 
             86 'UNFAV Capital depreciation: would lose money if sold now' 
             87 'UNFAV Other reasons why now is a bad time to sell' 
             88 'UNFAV Variable mortgage rate' 
           89 'UNFAV Economic policy; references to government/new president' 
             98 'DK' 99 'NA' /
   SHOMRN2   0 'No second mention' 
         10 'FAV Interest rate won''t get any lower (not codeable elsewhere)' 
             11 'FAV Prices are high/higher/won''t get any lower' 
             12 'FAV Seller''s market (under-supply of houses)' 
             13 'FAV Prices going down; sell before prices lower' 
             14 'FAV Prices won''t get any higher (not codeable 13)' 
             15 'FAV Lower down payment' 
             16 'FAV Interest rates are low (now)' 
             17 'FAV Credit easy to get; easy money, NA if 15, 16, 17, or 18' 
             18 'FAV Credit will be tighter later; interest rates will go up' 
             19 'FAV Lower taxes; taxes will be higher later' 
             21 'FAV People can afford to buy now' 
             23 'FAV Buying makes for good times/prosperity/high employment' 
            31 'FAV Supply inadequate, shortages now; may be shortages later' 
          33 'FAV Good time for existing homes, costs more to build new ones' 
             41 'FAV Seasonal references only' 
           42 'FAV R only says: If need to sell/need money this is good time' 
             44 'FAV Can use cash/capital for other investments' 
             45 'FAV Better to sell now, value of home may decline' 
   46 'FAV Capital appreciation: value of houses increased; good profits now' 
             47 'FAV Other good reasons (miscellaneous)' 
             48 'FAV Variable mortgage rate' 
             49 'FAV Economic policy; references to gov''t/new president' 
      50 'UNFAV Interest rates won''t get any lower (not codeable elsewhere)' 
             51 'UNFAV Prices are low/lower' 
             52 'UNFAV Buyer''s market; difficult to find buyers;' 
           53 'UNFAV Prices will rise later; future uncertainty about prices' 
             54 'UNFAV Interest rates low/lower' 
             55 'UNFAV Higher/Larger down payment required' 
             56 'UNFAV Interest rate too high; will go up' 
   57 'UNFAV Credit hard to get; financing difficult; pt system; tight money' 
          58 'UNFAV Interest rates will come down later; credit easier later' 
             59 'UNFAV Tax increase; (property) taxes too high; going higher' 
             61 'UNFAV People can''t afford to buy now; recession; inflation' 
       62 'UNFAV People should save money; future uncertain; bad times ahead' 
             63 'UNFAV Buying contributes to inflation/makes for bad times' 
        65 'UNFAV Energy crisis; shortages of fuels; high price of utilities' 
      71 'UNFAV Supply adequate; (no reference to influence on prices/deals)' 
             73 'UNFAV Bad time for older homes; people want newer homes' 
             81 'UNFAV R mentions only seasonal factors' 
             84 'UNFAV Home is good\better investment' 
             85 'UNFAV Rents are too high' 
             86 'UNFAV Capital depreciation: would lose money if sold now' 
             87 'UNFAV Other reasons why now is a bad time to sell' 
             88 'UNFAV Variable mortgage rate' 
           89 'UNFAV Economic policy; references to government/new president' 
             98 'DK' 99 'NA' /
   CAR       1 'Good' 3 'Pro-con' 5 'Bad' 8 'DK' 9 'NA' /
   CARRN1    0 'No second mention' 
             10 'FAV Interest rates won''t get any lower' 
             11 'FAV Prices are low/lower/stable/not too high' 
             12 'FAV Good buys available; sales, discounts' 
             13 'FAV Prices are going up, buy before prices higher' 
             14 'FAV Prices won''t get any lower' 15 'FAV Lower down payment' 
             16 'FAV Interest rates low' 
             17 'FAV Credit easy to get; easy money' 
             18 'FAV Interest rates are going higher' 
             19 'FAV Taxes low; will be higher' 20 'FAV Rebate/Bonus program' 
             21 'FAV People can afford to buy now; purchasing power up' 
             23 'FAV Buying makes for good times, prosperity' 
             25 'FAV Energy crisis lessened, availability of gas' 
             30 'FAV New cars get better mileage, due to gasahol' 
             31 'FAV Supply adequate, no shortages now' 
             32 'FAV Quality is good/better/may get worse' 
             33 'FAV New models have improvements; new features' 
             34 'FAV Great variety of models and sizes to choose from' 
             35 'FAV (New) Small (economy) cars' 
             36 'FAV Safety; new models are safer' 
             37 'FAV Safety devices will be on and that''s bad' 
             38 'FAV Anti-pollution devices (will be on, good)' 
             39 'FAV Anti-pollution devices (will be on, bad)' 
             40 'FAV Strikes: labor problems, union demands' 
             41 'FAV Seasonal reference only' 
             42 'FAV R says: if you need it, good time as any' 
             43 'FAV Low sales won''t last, will pick up soon' 
             44 'FAV NA whether 36 or 38, or both' 
             45 'FAV NA whether 37 or 39, or both' 
             46 'FAV New models are little changed from old' 
             47 'FAV Other good reasons (misc.)' 
             49 'FAV Economic policy, references to gov''t/president' 
             50 'UNFAV Interest rates won''t get any lower' 
             51 'UNFAV Prices are (too) high, prices are going up' 
             52 'UNFAV Seller''s market; few sales or discounts' 
             53 'UNFAV Prices will fall later, are falling' 
             54 'UNFAV Debt or credit is bad (NA why)' 
             55 'UNFAV Larger/higher down payment required' 
             56 'UNFAV Interest rates are high, will go up' 
             57 'UNFAV Credit hard to get, tight money' 
             58 'UNFAV Interest rates will fall later' 
             59 'UNFAV Taxes high, going higher' 
             60 'UNFAV Because rebate/bonus program will be over' 
             61 'UNFAV People can''t afford to buy now, times bad' 
             62 'UNFAV People should save money, bad times ahead' 
             63 'UNFAV Buying contributes to inflation, makes bad times' 
             65 'UNFAV Energy crisis, gas shortage, price of gas' 
             67 'UNFAV Environmental/ecology reasons; pollution' 
             70 'UNFAV Poor mileage (including due to gasahol)' 
             71 'UNFAV Supply inadequate; few cars on market' 
             72 'UNFAV Quality is poor; quality better later' 
             73 'UNFAV Poor designs; unattractive styling' 
             74 'UNFAV New types of cars will be intro soon' 
             75 'UNFAV New smaller cars' 
             76 'UNFAV Safety; later models will be safer' 
             77 'UNFAV Too many safe items (expensive, unneeded)' 
             78 'UNFAV Later models will pollute less' 
             79 'UNFAV Anti-pollution devices (will be on, bad)' 
             80 'UNFAV Strikes; labor problems' 
             81 'UNFAV R mentions only seasonal factors' 
             82 'UNFAV Imported car market; int''l references' 
             83 'UNFAV High sales can''t last, change is due' 
             84 'UNFAV NA whether 76, or 78, or both' 
             85 'UNFAV NA whether 77, or 79, or both' 
             86 'UNFAV Poor performance, not clear why' 
             87 'UNFAV Other reasons why now is a bad time to buy' 
             88 'UNFAV Cost of insurance' 
             89 'UNFAV Economic policy, references to gov''t/president' 
             90 'UNFAV Good for imported cars, bad for domestic' 
             91 'UNFAV Good time for new car, bad time for used' 
             92 'UNFAV Good time for used cars, bad time for new' 
             93 'UNFAV Depends on whether new or used' 
             94 'UNFAV Good time for small cars, bad for big cars' 
             95 'UNFAV Good time for big cars, bad for small cars' 
             96 'UNFAV Good for domestic cars, bad for imported' 98 'DK' 
             99 'NA' /
   CARRN2    0 'No second mention' 
             10 'FAV Interest rates won''t get any lower' 
             11 'FAV Prices are low/lower/stable/not too high' 
             12 'FAV Good buys available; sales, discounts' 
             13 'FAV Prices are going up, buy before prices higher' 
             14 'FAV Prices won''t get any lower' 15 'FAV Lower down payment' 
             16 'FAV Interest rates low' 
             17 'FAV Credit easy to get; easy money' 
             18 'FAV Interest rates are going higher' 
             19 'FAV Taxes low; will be higher' 20 'FAV Rebate/Bonus program' 
             21 'FAV People can afford to buy now; purchasing power up' 
             23 'FAV Buying makes for good times, prosperity' 
             25 'FAV Energy crisis lessened, availability of gas' 
             30 'FAV New cars get better mileage, due to gasahol' 
             31 'FAV Supply adequate, no shortages now' 
             32 'FAV Quality is good/better/may get worse' 
             33 'FAV New models have improvements; new features' 
             34 'FAV Great variety of models and sizes to choose from' 
             35 'FAV (New) Small (economy) cars' 
             36 'FAV Safety; new models are safer' 
             37 'FAV Safety devices will be on and that''s bad' 
             38 'FAV Anti-pollution devices (will be on, good)' 
             39 'FAV Anti-pollution devices (will be on, bad)' 
             40 'FAV Strikes: labor problems, union demands' 
             41 'FAV Seasonal reference only' 
             42 'FAV R says: if you need it, good time as any' 
             43 'FAV Low sales won''t last, will pick up soon' 
             44 'FAV NA whether 36 or 38, or both' 
             45 'FAV NA whether 37 or 39, or both' 
             46 'FAV New models are little changed from old' 
             47 'FAV Other good reasons (misc.)' 
             49 'FAV Economic policy, references to gov''t/president' 
             50 'UNFAV Interest rates won''t get any lower' 
             51 'UNFAV Prices are (too) high, prices are going up' 
             52 'UNFAV Seller''s market; few sales or discounts' 
             53 'UNFAV Prices will fall later, are falling' 
             54 'UNFAV Debt or credit is bad (NA why)' 
             55 'UNFAV Larger/higher down payment required' 
             56 'UNFAV Interest rates are high, will go up' 
             57 'UNFAV Credit hard to get, tight money' 
             58 'UNFAV Interest rates will fall later' 
             59 'UNFAV Taxes high, going higher' 
             60 'UNFAV Because rebate/bonus program will be over' 
             61 'UNFAV People can''t afford to buy now, times bad' 
             62 'UNFAV People should save money, bad times ahead' 
             63 'UNFAV Buying contributes to inflation, makes bad times' 
             65 'UNFAV Energy crisis, gas shortage, price of gas' 
             67 'UNFAV Environmental/ecology reasons; pollution' 
             70 'UNFAV Poor mileage (including due to gasahol)' 
             71 'UNFAV Supply inadequate; few cars on market' 
             72 'UNFAV Quality is poor; quality better later' 
             73 'UNFAV Poor designs; unattractive styling' 
             74 'UNFAV New types of cars will be intro soon' 
             75 'UNFAV New smaller cars' 
             76 'UNFAV Safety; later models will be safer' 
             77 'UNFAV Too many safe items (expensive, unneeded)' 
             78 'UNFAV Later models will pollute less' 
             79 'UNFAV Anti-pollution devices (will be on, bad)' 
             80 'UNFAV Strikes; labor problems' 
             81 'UNFAV R mentions only seasonal factors' 
             82 'UNFAV Imported car market; int''l references' 
             83 'UNFAV High sales can''t last, change is due' 
             84 'UNFAV NA whether 76, or 78, or both' 
             85 'UNFAV NA whether 77, or 79, or both' 
             86 'UNFAV Poor performance, not clear why' 
             87 'UNFAV Other reasons why now is a bad time to buy' 
             88 'UNFAV Cost of insurance' 
             89 'UNFAV Economic policy, references to gov''t/president' 
             90 'UNFAV Good for imported cars, bad for domestic' 
             91 'UNFAV Good time for new car, bad time for used' 
             92 'UNFAV Good time for used cars, bad time for new' 
             93 'UNFAV Depends on whether new or used' 
             94 'UNFAV Good time for small cars, bad for big cars' 
             95 'UNFAV Good time for big cars, bad for small cars' 
             96 'UNFAV Good for domestic cars, bad for imported' 98 'DK' 
             99 'NA' /
   INCQFM    
 1 'Income in open format (before 1990)/ Asked open format, answered open format' 
          2 'Asked open format, answered bracketed format: coded to midpoint' 
 3 'Income in bracket format (before 1990)/ Asked bracketed, answered bracketed: coded to midpoint' 
             /
   YTL10     1 'Bottom 10%' 5 'Top 90%' /
   YTL90     1 'Top 10%' 5 'Bottom 90%' /
   YTL50     1 'Bottom 50%' 5 'Top 50%' /
   YTL5      1 'Bottom 20%' 2 '21-40%' 3 '41-60%' 4 '61-80%' 5 'Top 20%' /
   YTL4      1 'Bottom 25%' 2 '26-50%' 3 '51-75%' 4 'Top 25%' /
   YTL3      1 'Bottom 33%' 2 'Middle 33%' 3 'Top 33%' /
   HOMEOWN   1 'Owns home' 2 'Does not own home' 99 'NA' /
   HOMEQFM   1 'Asked open format, answered open format' 
          2 'Asked open format, answered bracketed format: coded to midpoint' 
   3 'Asked bracketed question, answered bracketed format: coded to midpoint' 
             /
   HTL10     1 'Bottom 10%' 5 'Top 90%' /
   HTL90     1 'Top 10%' 5 'Bottom 90%' /
   HTL50     1 'Bottom 50%' 5 'Top 50%' /
   HTL5      1 'Bottom 20%' 2 '21-40%' 3 '41-60%' 4 '61-80%' 5 'Top 20%' /
   HTL4      1 'Bottom 25%' 2 '26-50%' 3 '51-75%' 4 'Top 25%' /
   HTL3      1 'Bottom 33%' 2 'Middle 33%' 3 'Top 33%' /
   HOMEVAL   1 'Increased in value' 3 'Same' 5 'Decreased in value' 8 'DK' 
             9 'NA' /
   HOMPX1Q1  1 'Increase' 3 'About the same' 5 'Decrease' 8 'DK' 9 'NA' /
   HOMPX1Q2  998 'DK' 999 'NA' /
   HOMPX1    -997 'DK how much down' 996 'DK how much up' 
             998 'DK whether up or down' 999 'NA' /
   HOMPX5Q1  1 'Increase' 3 'Remain about the same' 5 'Decrease' 8 'DK' 
             9 'NA' /
   HOMPX5Q2  998 'DK' 999 'NA' /
   HOMPX5    -997 'DK how much down' 996 'DK how much up' 
             998 'DK whether up or down' 999 'NA' /
   INVEST    1 'Yes' 5 'No (includes No, DK, NA, and *)' /
   INVQFM    1 'Asked open format, answered open format' 
          2 'Asked open format, answered bracketed format: coded to midpoint' 
     3 'Asked bracketed format, answered bracketed format: coded to midpoint' 
             /
   STL10     1 'Bottom 10%' 5 'Top 90%' /
   STL90     1 'Top 10%' 5 'Top 90%' /
   STL50     1 'Bottom 50%' 5 'Top 50%' /
   STL5      1 'Bottom 20%' 2 '21-40%' 3 '41-60%' 4 '61-80%' 5 'Top 20%' /
   STL4      1 'Bottom 25%' 2 '26-50%' 3 '51-75%' 4 'Top 25%' /
   STL3      1 'Bottom 33%' 2 'Middle 33%' 3 'Top 33%' /
   AGE       97 '97 or older' /
   BIRTHM    1 'January' 2 'February' 3 'March' 4 'April' 5 'May' 6 'June' 
             7 'July' 8 'August' 9 'September' 10 'October' 11 'November' 
             12 'December' /
   REGION    1 'West' 2 'North Central' 3 'Northeast' 4 'South' /
   SEX       1 'Male' 2 'Female' /
   MARRY     1 'Married/partner (includes spouse absent)' 
             3 'Divorced (includes separated)' 4 'Widowed' 5 'Never married' 
             /
   NUMKID    0 'None' /
   NUMADT    5 '5 or more' /
   EDUC      1 'Grade 0-8 no hs diploma' 2 'Grade 9-12 no hs diploma' 
             3 'Grade 0-12 w/ hs diploma' 4 'Grade 13-17 no col degree' 
             5 'Grade 13-16 w/ col degree' 6 'Grade 17 W/ col degree' /
   ECLGRD    1 'Yes' 5 'No' 8 'DK' 9 'NA' /
   EHSGRD    1 'Yes' 5 'No' 8 'DK' 9 'NA' /
   EGRADE    98 'DK' 99 'NA' /
   EDUCATION 1 'Grade 1 through 12, no diploma' 
             2 'High school diploma or GED' 3 'Some college, no degree' 
             4 'Associate''s degree (ex. AA, AS) or Vocational certification' 
             5 'Bachelor''s degree (ex. BA, BS)' 
             6 'Master''s degree (ex. MA, MS, MEng, MEd, MSW, MBA)' 
 7 'Professional degree beyond a bachelor''s degree (ex. MD, DDS, DVM, LLB, JD)' 
             8 'Doctorate degree (ex. PhD, EdD)' 99 'NA' /
   POLAFF    1 'Republican' 2 'Democrat' 3 'Independent, No Preference' 
             8 'DK' 9 'NA' /
   POLREP    1 'Strong' 5 'Not So Strong' 8 'DK' 9 'NA' /
   POLDEM    1 'Strong' 5 'Not So Strong' 8 'DK' 9 'NA' /
   POLCRD    1 'Closer to Republican' 5 'Closer to Democratic' 6 'Neither' 
             8 'DK' 9 'NA' /
   VEHOWN    1 'Yes' 5 'No' 8 'DK' 9 'NA' /
   VEHNUM    98 'DK' 99 'NA' /
   GASPX1    1 'Go up' 3 'Stay the same' 5 'Go down' 8 'DK' 9 'NA' /
   GASPX2    995 '995 cents or more' 998 'DK' 999 'NA' /
   GAS5      -997 'DK how much down' -995 '-995 cents or less' 
             995 '995 cents or more' 996 'DK how much up' 
             998 'DK whether up or down' 999 'NA' /
   GAS1PX1   1 'Go up' 3 'Stay the same' 5 'Go down' 8 'DK' 9 'NA' /
   GAS1PX2   995 '995 cents or more' 998 'DK' 999 'NA' /
   GAS1      -997 'DK how much down' 996 'DK how much up' 
             998 'DK whether up or down' 999 'NA' /
   PINC      998 'DK' 999 'NA' /
   PINC2     996 'Volunteered ''No personal income'' (Only for METHOD=1)' 
             998 'DK' 999 'NA' /
   PJOB      998 'DK' 999 'NA' /
   PSSA      998 'DK' 999 'NA' /
   PCRY      1 'Gone up' 3 'Same' 5 'Gone down' 8 'DK' 9 'NA' /
   PSTK      998 'DK' 999 'NA' /
   .

COMMENT  md, min and max specifications were translated into the
COMMENT following "MISSING VALUES" commands and "IF" statements:.

IF (PAGO GE 8) PAGO = $SYSMIS.
IF (PAGOR1 GE 98) PAGOR1 = $SYSMIS.
IF (PAGOR2 GE 98) PAGOR2 = $SYSMIS.
IF (PAGO5 GE 8) PAGO5 = $SYSMIS.
IF (PEXP GE 8) PEXP = $SYSMIS.
IF (PEXP5 GE 8) PEXP5 = $SYSMIS.
IF (INEXQ1 GE 8) INEXQ1 = $SYSMIS.
IF (INEXQ2 GE 98) INEXQ2 = $SYSMIS.
IF (INEXQ2 GT 95) INEXQ2 = $SYSMIS.
IF (INEXQ2 LT 0) INEXQ2 = $SYSMIS.
MISSING VALUES  INEX (-97).
IF (INEX GE 96) INEX = $SYSMIS.
IF (INEX GT 95) INEX = $SYSMIS.
IF (INEX LT -95) INEX = $SYSMIS.
IF (RINC GE 8) RINC = $SYSMIS.
IF (BAGO GE 8) BAGO = $SYSMIS.
IF (BEXP GE 8) BEXP = $SYSMIS.
IF (BUS12 GE 8) BUS12 = $SYSMIS.
IF (BUS5 GE 98) BUS5 = $SYSMIS.
IF (NEWS1 GE 98) NEWS1 = $SYSMIS.
IF (NEWS2 GE 98) NEWS2 = $SYSMIS.
IF (UNEMP GE 8) UNEMP = $SYSMIS.
IF (GOVT GE 8) GOVT = $SYSMIS.
IF (RATEX GE 8) RATEX = $SYSMIS.
IF (PX1Q1 GE 8) PX1Q1 = $SYSMIS.
IF (PX1Q2 GE 98) PX1Q2 = $SYSMIS.
IF (PX1Q2 GT 95) PX1Q2 = $SYSMIS.
IF (PX1Q2 LT 1) PX1Q2 = $SYSMIS.
MISSING VALUES  PX1 (-97).
IF (PX1 GE 96) PX1 = $SYSMIS.
IF (PX1 GT 95) PX1 = $SYSMIS.
IF (PX1 LT -95) PX1 = $SYSMIS.
IF (PX5Q1 GE 8) PX5Q1 = $SYSMIS.
IF (PX5Q2 GE 98) PX5Q2 = $SYSMIS.
IF (PX5Q2 GT 95) PX5Q2 = $SYSMIS.
IF (PX5Q2 LT 1) PX5Q2 = $SYSMIS.
MISSING VALUES  PX5 (-97).
IF (PX5 GE 96) PX5 = $SYSMIS.
IF (PX5 GT 95) PX5 = $SYSMIS.
IF (PX5 LT -95) PX5 = $SYSMIS.
IF (DUR GE 8) DUR = $SYSMIS.
IF (DURRN1 GE 98) DURRN1 = $SYSMIS.
IF (DURRN2 GE 98) DURRN2 = $SYSMIS.
IF (HOM GE 8) HOM = $SYSMIS.
IF (HOMRN1 GE 98) HOMRN1 = $SYSMIS.
IF (HOMRN2 GE 98) HOMRN2 = $SYSMIS.
IF (SHOM GE 8) SHOM = $SYSMIS.
IF (CAR GE 8) CAR = $SYSMIS.
IF (CARRN1 GE 98) CARRN1 = $SYSMIS.
IF (CARRN2 GE 98) CARRN2 = $SYSMIS.
IF (HOMEOWN GE 99) HOMEOWN = $SYSMIS.
IF (HOMEAMT GE 9999998) HOMEAMT = $SYSMIS.
IF (HOMEVAL GE 8) HOMEVAL = $SYSMIS.
IF (HOMPX1Q1 GE 8) HOMPX1Q1 = $SYSMIS.
IF (HOMPX1Q2 GE 998.0) HOMPX1Q2 = $SYSMIS.
IF (HOMPX1Q2 GT 35) HOMPX1Q2 = $SYSMIS.
IF (HOMPX1Q2 LT -35) HOMPX1Q2 = $SYSMIS.
MISSING VALUES  HOMPX1 (-997.0).
IF (HOMPX1 GE 996.0) HOMPX1 = $SYSMIS.
IF (HOMPX1 GT 35) HOMPX1 = $SYSMIS.
IF (HOMPX1 LT -35) HOMPX1 = $SYSMIS.
IF (HOMPX5Q1 GE 8) HOMPX5Q1 = $SYSMIS.
IF (HOMPX5Q2 GE 998.0) HOMPX5Q2 = $SYSMIS.
IF (HOMPX5Q2 GT 35) HOMPX5Q2 = $SYSMIS.
IF (HOMPX5Q2 LT -35) HOMPX5Q2 = $SYSMIS.
MISSING VALUES  HOMPX5 (-997.0).
IF (HOMPX5 GE 996.0) HOMPX5 = $SYSMIS.
IF (HOMPX5 GT 35) HOMPX5 = $SYSMIS.
IF (HOMPX5 LT -35) HOMPX5 = $SYSMIS.
IF (INVAMT GE 99999998) INVAMT = $SYSMIS.
IF (AGE GT 97) AGE = $SYSMIS.
IF (AGE LT 17) AGE = $SYSMIS.
IF (NUMKID GT 5) NUMKID = $SYSMIS.
IF (NUMKID LT 0) NUMKID = $SYSMIS.
IF (NUMADT GE 9) NUMADT = $SYSMIS.
IF (NUMADT GT 5) NUMADT = $SYSMIS.
IF (NUMADT LT 1) NUMADT = $SYSMIS.
IF (ECLGRD GE 8) ECLGRD = $SYSMIS.
IF (EHSGRD GE 8) EHSGRD = $SYSMIS.
IF (EGRADE GE 98) EGRADE = $SYSMIS.
IF (EGRADE GT 17) EGRADE = $SYSMIS.
IF (EGRADE LT 1) EGRADE = $SYSMIS.
IF (EDUCATION GE 98) EDUCATION = $SYSMIS.
IF (VEHOWN GE 8) VEHOWN = $SYSMIS.
IF (VEHNUM GE 98) VEHNUM = $SYSMIS.
IF (GASPX1 GE 8) GASPX1 = $SYSMIS.
IF (GASPX2 GE 998) GASPX2 = $SYSMIS.
IF (GASPX2 GT 300) GASPX2 = $SYSMIS.
IF (GASPX2 LT 0) GASPX2 = $SYSMIS.
MISSING VALUES  GAS5 (-997).
IF (GAS5 GE 996) GAS5 = $SYSMIS.
IF (GAS5 GT 300) GAS5 = $SYSMIS.
IF (GAS5 LT -150) GAS5 = $SYSMIS.
IF (GAS1PX1 GE 8) GAS1PX1 = $SYSMIS.
IF (GAS1PX2 GE 998) GAS1PX2 = $SYSMIS.
IF (GAS1PX2 GT 200) GAS1PX2 = $SYSMIS.
IF (GAS1PX2 LT 0) GAS1PX2 = $SYSMIS.
MISSING VALUES  GAS1 (-997).
IF (GAS1 GE 996) GAS1 = $SYSMIS.
IF (GAS1 GT 200) GAS1 = $SYSMIS.
IF (GAS1 LT -100) GAS1 = $SYSMIS.
IF (PINC GE 998.00) PINC = $SYSMIS.
IF (PINC GT 100) PINC = $SYSMIS.
IF (PINC LT 0) PINC = $SYSMIS.
IF (PINC2 GE 998.00) PINC2 = $SYSMIS.
IF (PINC2 GT 100) PINC2 = $SYSMIS.
IF (PINC2 LT 0) PINC2 = $SYSMIS.
IF (PJOB GE 998.00) PJOB = $SYSMIS.
IF (PJOB GT 100) PJOB = $SYSMIS.
IF (PJOB LT 0) PJOB = $SYSMIS.
IF (PSSA GE 998.00) PSSA = $SYSMIS.
IF (PSSA GT 100) PSSA = $SYSMIS.
IF (PSSA LT 0) PSSA = $SYSMIS.
IF (PCRY GE 8) PCRY = $SYSMIS.
IF (PSTK GE 998.00) PSTK = $SYSMIS.

SAVE OUTFILE=y  /* Replace 'y' with name to give your system file
   /MAP
   /COMPRESSED  /* Delete this line if you want an uncompressed file
   .
