import Foundation

struct ExerciseData {
    static let allExercises: [Exercise] = [

        // MARK: - Hantelövningar

        Exercise(
            name: "Bicepscurl",
            muscleGroups: ["Biceps"],
            description: "En klassisk bicepsövning utförd sittande i rullstolen med hantel.",
            steps: [
                "Sitt rakt i stolen med armen hängande rakt ner och knogarna vända ut från kroppen.",
                "Böj i armbågen men var stilla med överarmen. Lyft underarmen uppåt samtidigt som du roterar handen ett kvarts varv så att knogarna pekar framåt."
            ],
            tips: "Ha aldrig tyngre vikter än att du kan göra övningen som den är beskriven. Bromsa vikterna ner till utgångsläget.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.nybörjare, .mellannivå, .avancerad]
        ),

        Exercise(
            name: "Tricepspress",
            muscleGroups: ["Triceps"],
            description: "Isoleringsövning för triceps utförd med hantel bakom huvudet.",
            steps: [
                "Lyft armen bakom huvudet så armbågen pekar uppåt.",
                "Håll överarmen stilla, räta ut armen genom att trycka underarmen uppåt."
            ],
            tips: "Armbågen ska vara stilla under hela övningen. Bromsa vikterna ner till utgångsläget.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 6,
            repsMax: 10,
            levels: [.nybörjare, .mellannivå, .avancerad]
        ),

        Exercise(
            name: "Ryggflyes",
            muscleGroups: ["Mellan skulderbladen", "Övre rygg", "Baksida axlar"],
            description: "Övning för övre rygg och bakre axlar med hantlar.",
            steps: [
                "Ligg fram i stolen med armarna hängande nedåt, knogarna utåt.",
                "Böj i armbågen. Håll kvar böjningen statiskt. Lyft uppåt-utåt, med skulderbladen. Håll ett kort ögonblick. Gå tillbaka."
            ],
            tips: "Koncentrera dig på att jobba med rygg och baksida axlar.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Rygglyft",
            muscleGroups: ["Övre rygg", "Mellan skulderbladen"],
            description: "Effektiv ryggövning med hantlar i framåtlutad position.",
            steps: [
                "Ligg ner helt mot låren. Båda armarna hängande ner mot golvet med knogarna nedåt.",
                "Lyft hantlarna parallellt uppåt och böj i armbågarna. Pressa ihop skulderbladen. Håll ett kort ögonblick och bromsa tillbaka till utgångsläget."
            ],
            tips: "Ryck inte upp hantlarna, kör med jämn takt.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.nybörjare, .mellannivå, .avancerad]
        ),

        Exercise(
            name: "Ryggövning med hantel",
            muscleGroups: ["Övre rygg", "Baksida överarm"],
            description: "Ryggövning med rotation av hantlarna för maximal aktivering.",
            steps: [
                "Sitt något framåtlutad i stolen, med armarna hängande nedåt och knogarna utåt.",
                "Dra båda armarna parallellt bakåt, samtidigt som du vrider händerna så att handlederna ligger parallellt uppåt mot taket. Bromsa tillbaka till utgångsläget."
            ],
            tips: "Spänn ryggen och håll några sekunder. Bromsa på tillbakavägen.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.avancerad]
        ),

        Exercise(
            name: "Boxövning",
            muscleGroups: ["Baksida överarm", "Axlar", "Rygg", "Bröst", "Bål"],
            description: "Dynamisk uppvärmningsövning som ger puls och värmer upp hela överkroppen.",
            steps: [
                "Utgå med båda hantlarna strax under hakan.",
                "Slå med ena hanteln rakt ut, snett uppåt och rotera med kroppen samtidigt. När du drar tillbaka armen till utgångsläget slår du ut med andra armen. Repetera växelvis."
            ],
            tips: "Kör med lätta hantlar i ganska högt tempo. Kör på tid 30-60 sekunder och 3-4 set. Ger puls. Utmärkt uppvärmningsövning.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 4,
            repsMin: 30,
            repsMax: 60,
            durationSeconds: 45,
            levels: [.nybörjare, .mellannivå, .avancerad],
            isWarmup: true
        ),

        Exercise(
            name: "Underarmscurl",
            muscleGroups: ["Underarmsmuskeln"],
            description: "Isoleringsövning för underarmens böjmuskler.",
            steps: [
                "Lägg ovansidan av underarmen på låret med handleden utanför knäet. Häng ned handen, lyft handen och spänn underarmsmuskeln. Bromsa tillbaka."
            ],
            tips: "Var försiktig. Ha inte för tung vikt. Om det gör ont i handleden, avbryt.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Handledsövning 1",
            muscleGroups: ["Övre delen av underarmen", "Stabiliserar handleden"],
            description: "Handledsövning för att stärka underarmens böjmuskler och stabilisera handleden.",
            steps: [
                "Lägg underarmen på låret så att hanteln pekar lodrätt framför knäet.",
                "Vinkla i handleden uppåt. Håll kvar ett ögonblick i övre läget och bromsa tillbaka."
            ],
            tips: "Var försiktig. Om det gör ont i handleden, avbryt.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Handledsövning 2",
            muscleGroups: ["Ovansidan av underarmen"],
            description: "Handledsövning för att stärka ovansidan av underarmen.",
            steps: [
                "Lägg underarmen på låret med undersidan mot låret.",
                "Lyft handen uppåt. Bromsa tillbaka."
            ],
            tips: "Lätta vikter. Kör ej om smärta i leden uppstår.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Axellyft",
            muscleGroups: ["Axlar"],
            description: "Skulderlyft med hantlar för att stärka axlarna.",
            steps: [
                "Sitt rakt i stolen med armarna hängande och med knogarna vända ut från kroppen.",
                "Slappna av i armarna lyft samtidigt båda axlarna uppåt. Bromsa vikterna ner till utgångsläget."
            ],
            tips: "Var avslappnad i armarna så att du enbart arbetar med axlarna.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.nybörjare, .mellannivå, .avancerad]
        ),

        Exercise(
            name: "Hantelpress bakom nacke",
            muscleGroups: ["Baksida rygg", "Triceps"],
            description: "Pressövning med hantlar bakom nacken för rygg och triceps.",
            steps: [
                "Lägg hantlarna bakom nacken som om det vore en stång.",
                "Pressa upp parallellt med båda armarna tills armarna är raka. Bromsa och sänk sakta parallellt tillbaka bakom nacke."
            ],
            tips: "Försök sitta så rakt som möjligt. Var noga med att rörelsen går bakom huvudet i hela rörelsen.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 15,
            repsMax: 20,
            levels: [.avancerad]
        ),

        Exercise(
            name: "Flyes",
            muscleGroups: ["Axlar", "Rygg", "Bröst"],
            description: "Sidolyft med hantlar som tränar axlar, rygg och bröst beroende på sittställning.",
            steps: [
                "Sitt med armarna hängande utmed sidorna. Böj lätt i armbågen.",
                "Lyft armarna rakt ut från kroppen tills axeln nått 90 grader. Behåll den lätta böjningen i armbågsleden under hela rörelsen. Bromsa vikterna på nervägen."
            ],
            tips: "Sitter du upprätt tar det mest på axlarna. Sitter du mer framåtlutad tar det mer på ryggen. OBS! Gå bara upp 90 grader i axeln.",
            equipment: .hantel,
            setsMin: 3,
            setsMax: 3,
            repsMin: 10,
            repsMax: 15,
            levels: [.mellannivå, .avancerad]
        ),

        // MARK: - Stångövningar

        Exercise(
            name: "Axelpress",
            muscleGroups: ["Axlar", "Deltamuskel"],
            description: "Pressövning med stång för axlar och deltamuskler.",
            steps: [
                "Lägg stången mot bröstet lyft rakt upp tills armarna är helt raka ovanför huvudet.",
                "Sänk stången ner bakom nacken, lyft upp igen över huvudet sänk ner till bröstet igen."
            ],
            tips: "Håll huvudet rakt, håll inte för brett med armarna. Rekommenderas ej om du har dålig rörlighet i axlarna.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Sned bröstpress uppåt",
            muscleGroups: ["Övre bröstmuskler"],
            description: "Bröstpress med stång i bakåtlutad position för övre bröstmuskler.",
            steps: [
                "Flytta fram i stolen så att du sitter lite bakåtlutad. Lägg stången på bröstet pressa snett uppåt.",
                "Gå sakta tillbaka till bröstet igen."
            ],
            tips: "Varieras genom att hålla brett eller smalt grepp på stången. Brett grepp = mer bröstmuskler. Smalt grepp = mer triceps.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Sittande bålrotation",
            muscleGroups: ["Bukmuskulatur", "Rörlighet"],
            description: "Rotationsövning med stång för bålstyrka och rörlighet.",
            steps: [
                "Lägg stången bakom nacken. Vrid kroppen växelvis till höger och vänster."
            ],
            tips: "Gå inte ut i ytterlägen. Bromsa med magmusklerna.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Underarmscurls med stång",
            muscleGroups: ["Underarmsmuskler"],
            description: "Handledsflexion med stång för underarmsstyrka.",
            steps: [
                "Lägg underarmarna på låren med handlederna precis utanför knäet. Håll stången med knogarna neråt. Lyft uppåt och sänk igen."
            ],
            tips: "Handlederna är känsliga var försiktig. Kör inte om det gör ont.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Propeller",
            muscleGroups: ["Axlar", "Rygg"],
            description: "Rotationsövning med stång för axlar och rygg.",
            steps: [
                "Håll stången framför dig rakt ut, håll något smalare än axelbrett. Behåll armarna raka och rotera stången 90 grader höger och 90 grader vänster växelvis."
            ],
            tips: "Ha inte för hög hastighet. Bromsa och slå stopp vid 90 grader.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.avancerad]
        ),

        Exercise(
            name: "Ryggövning med stång",
            muscleGroups: ["Övre rygg"],
            description: "Ryggövning med stång i framåtlutad position.",
            steps: [
                "Ligg ner framåt i stolen. Håll stången något bredare än axelbredd med raka armar ner mot golvet.",
                "Dra armarna uppåt så långt det går. Sänk sakta ner igen."
            ],
            tips: "Titta ner i golvet. Spänn inte nacken.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Drag upp till hakan",
            muscleGroups: ["Kappmuskeln", "Deltamuskel"],
            description: "Drag med stång uppåt till hakan för kapp- och deltamuskeln.",
            steps: [
                "Sitt rakt upp i stolen. Håll ganska smalt mellan händerna och ha armarna och stången hängande framför dig.",
                "Dra stången uppåt ända upp till hakan."
            ],
            tips: "Var noga med att sitta rakt. Titta rakt framåt.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.avancerad]
        ),

        Exercise(
            name: "Töjningsövning",
            muscleGroups: ["Rörlighet i rygg och axlar"],
            description: "Töjnings- och rörlikhetsövning med stång för rygg och axlar.",
            steps: [
                "Håll stången något bredare än axelbredd, rakt över huvudet.",
                "Luta från sida till sida samtidigt som du drar lite med höger arm när du lutar åt höger och tvärtom åt vänster."
            ],
            tips: "Ta inte ut rörelsen för långt.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.nybörjare, .mellannivå, .avancerad]
        ),

        Exercise(
            name: "Paddel",
            muscleGroups: ["Bålrotation", "Sneda bukmuskulaturen", "Rygg", "Armar", "Axlar"],
            description: "Paddlingsimitation med stång för bål, rygg och axlar.",
            steps: [
                "Paddla med stången växelvis på höger och vänster sida."
            ],
            tips: "Ta inte ut rörelsen för långt så du gör illa ryggen.",
            equipment: .stång,
            setsMin: 3,
            setsMax: 3,
            repsMin: 20,
            repsMax: 30,
            levels: [.avancerad]
        ),

        // MARK: - Kroppsviktsövningar

        Exercise(
            name: "Pushups från stolen",
            muscleGroups: ["Bröst", "Triceps", "Axlar"],
            description: "Push-up utförd från armstöden på rullstolen.",
            steps: [
                "Placera händerna på armstöden.",
                "Pressa upp kroppen med armarna. Sänk kontrollerat tillbaka."
            ],
            tips: "Var försiktig. Börja med få repetitioner.",
            equipment: .kroppsvikt,
            setsMin: 3,
            setsMax: 3,
            repsMin: 5,
            repsMax: 15,
            levels: [.mellannivå, .avancerad]
        ),

        Exercise(
            name: "Tricepsdips på stolen",
            muscleGroups: ["Triceps"],
            description: "Dips-övning utförd från hjulringen eller armstöden för triceps.",
            steps: [
                "Placera händerna på hjulringen eller armstöden.",
                "Pressa upp kroppen och sänk kontrollerat."
            ],
            tips: "Kräver god balans och armstyrka.",
            equipment: .kroppsvikt,
            setsMin: 3,
            setsMax: 3,
            repsMin: 8,
            repsMax: 12,
            levels: [.avancerad]
        )
    ]

    static func exercises(for level: ActivityLevel) -> [Exercise] {
        allExercises.filter { $0.levels.contains(level) }
    }

    static func exercises(for equipment: Equipment) -> [Exercise] {
        allExercises.filter { $0.equipment == equipment }
    }
}
