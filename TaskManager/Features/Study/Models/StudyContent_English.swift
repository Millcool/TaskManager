import Foundation

enum StudyContent_English {
    static func makeGroup() -> StudyGroup {
        StudyGroup(
            title: "Английский язык (вступительный)",
            subtitle: "Формат, чтение, перевод, устная часть, типовые задания",
            iconSystemName: "character.book.closed",
            topics: [examFormat, academicReading, translation, oralPart, commonMistakes]
        )
    }

    static var examFormat: StudyTopic {
        StudyTopic(
            title: "Формат вступительного экзамена",
            summary: "Что обычно включает экзамен по английскому в аспирантуру и как к нему готовиться.",
            questions: [
                StudyQuestion(
                    question: "Из чего обычно состоит кандидатский экзамен / вступительное испытание по английскому?",
                    answer: "Стандартная структура (ФГОС для аспирантуры): 1) Чтение оригинального научного текста по специальности (~1500–2500 знаков) со словарём — письменный перевод фрагмента (~500 знаков) за 45–60 минут. 2) Реферативный/беглый перевод более крупного текста без словаря. 3) Устное собеседование: краткий пересказ прочитанного, ответы на вопросы комиссии по теме исследования и специальности. Конкретные требования варьируются: в ВШЭ — внутренний тест формата IELTS Academic; в МФТИ — близко к ФГОС.",
                    examples: "Типичный письменный фрагмент — отрывок из Nature/IEEE Transactions/ACM. Темы: близкие к специальности поступающего, но не обязательно из его узкой области."
                ),
                StudyQuestion(
                    question: "Какой уровень нужен и как его подтвердить?",
                    answer: "По ФГОС для кандидатского — уровень B2 (Upper-Intermediate). Для топ-программ на английском (Сколтех, ВШЭ international) — C1/Advanced. Сертификаты IELTS (≥6.5) или TOEFL iBT (≥79) часто засчитывают полностью или частично. Важно уметь: читать аутентичные статьи без постоянного словаря; вести академический разговор; писать краткий abstract/summary.",
                    examples: "Сколтех требует IELTS Academic ≥6.5 или TOEFL iBT ≥79 на момент подачи. Некоторые вузы принимают Duolingo English Test (≥110)."
                ),
                StudyQuestion(
                    question: "Как подготовить «тему» к устной части?",
                    answer: "На собеседовании практически всегда спрашивают: расскажите о себе, о научных интересах, о будущей диссертации. Подготовьте 3 устных рассказа: 1) «About myself» (2-3 мин): education, current work, why PhD; 2) «Research interests» (2-3 мин): area, key problems, your angle; 3) «Thesis topic» (3-4 мин): title, motivation, methods, expected contribution. Репетируйте вслух — комиссия будет задавать уточняющие вопросы.",
                    examples: "Не заучивайте дословно — попросите носителя/преподавателя задать follow-up questions: What methods do you plan to use? What is the novelty? What literature have you reviewed?"
                ),
                StudyQuestion(
                    question: "Как готовиться за 1-2 месяца?",
                    answer: "1) Ежедневно 30-60 мин чтения статей по специальности (arXiv, IEEE, ACM) — выписывать 10-15 новых терминов в день. 2) 2-3 раза в неделю: переводите abstract или введение статьи письменно, сверяйте с DeepL/профессиональным переводом. 3) Раз в неделю: запишите ответ на один из типовых вопросов (5 мин), послушайте себя. 4) Смотрите лекции на YouTube (MIT OCW, Stanford) — приучает к академической речи.",
                    examples: "Сервисы: LingQ, Goodreads для научпопа, Anki для терминологии специальности. Русско-английский глоссарий ВАК — полезен для формальных конструкций."
                ),
                StudyQuestion(
                    question: "Какие ошибки чаще всего снижают оценку?",
                    answer: "1) Дословный перевод с русского (калька), неестественные конструкции. 2) Путаница артиклей, особенно в научных терминах (the method vs a method vs method). 3) Неправильные предлоги (depend *on*, consist *of*, differ *from*). 4) Неверные времена: Present Perfect для «уже сделано», Past Simple для законченного в прошлом. 5) Произношение технических терминов (algorithm, hypothesis, parameter). 6) Паузы и «ээ» вместо fillers (well, actually, let me think).",
                    examples: "Типичная калька: «It is interested that...» ← «Интересно, что...». Правильно: «It is interesting that...» или «Interestingly,...»."
                )
            ]
        )
    }

    static var academicReading: StudyTopic {
        StudyTopic(
            title: "Академическое чтение",
            summary: "Стратегии работы с научным текстом, структура статьи, типовая лексика.",
            questions: [
                StudyQuestion(
                    question: "Какая типовая структура научной статьи IMRAD?",
                    answer: "IMRAD: Introduction, Methods, Results, And Discussion (+ Abstract, Conclusion, References). Abstract — сжатая версия всего (150–300 слов). Introduction: контекст → gap → contribution статьи. Methods: воспроизводимое описание. Results: факты без интерпретации. Discussion: интерпретация, ограничения, связь с литературой. Для быстрого обзора: читайте abstract + introduction + conclusion; если intересно — figures и results.",
                    examples: "Для экзамена обычно дают Introduction или комбинацию Introduction+Results одной статьи — именно там больше всего ключевых терминов и типовых академических конструкций."
                ),
                StudyQuestion(
                    question: "Как определить главную мысль абзаца и статьи?",
                    answer: "В академическом тексте главная мысль обычно в первом предложении абзаца (topic sentence), детали и примеры — далее. Ключевые слова для структуры: however, therefore, in contrast, for example, in particular. В статье: гипотеза — в конце Introduction; основной вывод — в начале Discussion/Conclusion. На экзамене первое, что нужно понять: какая проблема, какое решение, каков вклад.",
                    examples: "Связующие слова: «Thus» (следовательно), «In contrast» (в противоположность), «Furthermore» (более того), «Specifically» (в частности). По ним строится логическая карта."
                ),
                StudyQuestion(
                    question: "Что такое hedging и почему он важен в английской науке?",
                    answer: "Hedging — смягчение утверждений, признак научного стиля. Вместо «The method is the best» пишут «The method appears to outperform baselines / is likely / may / tends to / suggests that». Это не трусость, а честность о ограничениях. Типовые средства: may/might/could, appear/seem/tend, some/most/in most cases, evidence suggests, we argue that. Отсутствие hedging звучит наивно.",
                    examples: "«Our results prove X» (слишком сильно) → «Our results suggest that X holds in the studied setting». Второй вариант — академически корректный."
                ),
                StudyQuestion(
                    question: "Коллокации и термины, которые стоит знать.",
                    answer: "Исследовательские: conduct a study, address the problem, provide evidence, draw a conclusion, raise a question, confirm/reject a hypothesis. Сравнение: significantly higher, on par with, outperform, comparable to. Оценка вклада: novel contribution, state-of-the-art, prior work, our key finding. Методы: propose, design, evaluate, assess, demonstrate. Важно: не путать научные термины с общеупотребительными (significant = статистически значимый, а не «важный»).",
                    examples: "«Our method achieves state-of-the-art results on benchmark X, outperforming prior work by Y points» — почти готовый шаблон предложения из любого research abstract."
                ),
                StudyQuestion(
                    question: "Как работать с незнакомыми терминами на экзамене?",
                    answer: "1) Сначала попробуйте понять из контекста и морфологии (приставки, корни). 2) Если термин ключевой — ищите в словаре; если не ключевой — пропускайте. 3) Композитные термины: разбивайте (convolutional → convolve + ion + al; neural network embedding → embedding of a neural network). 4) Не тратьте >2 мин на одно слово. 5) Для комиссии честнее сказать «this term is new to me, but from the context I understand it as...», чем угадать неправильно.",
                    examples: "«Eigenvalue» — если знать что eigen = «собственный» (нем.), становится ясно. «Back-propagation» — из двух простых слов."
                )
            ]
        )
    }

    static var translation: StudyTopic {
        StudyTopic(
            title: "Письменный перевод",
            summary: "Грамматические ловушки, пассив, герундий, термины, стиль.",
            questions: [
                StudyQuestion(
                    question: "Как переводить длинные предложения с причастными оборотами?",
                    answer: "Английские научные предложения часто длинные с participle phrases. Алгоритм: 1) Найти главное подлежащее и сказуемое. 2) Выделить причастные/деепричастные обороты, союзные слова. 3) Переводить с разбиением на 2-3 русских предложения, если в английском оно перегружено. 4) Сохранять связки (however, thus, while). 5) При необходимости менять порядок (в русском тема обычно в начале).",
                    examples: "«The method, combining two approaches and previously shown to outperform baselines, was tested on a large dataset.» → «Метод, объединяющий два подхода и ранее показавший преимущество над базовыми решениями, был протестирован на большом наборе данных.»"
                ),
                StudyQuestion(
                    question: "Особенности перевода пассивного залога.",
                    answer: "В английской науке пассив частотнее, чем в русской. Варианты перевода: 1) полный пассив («was studied» → «был изучен»); 2) неопределённо-личное («изучили»); 3) возвратное («изучается»); 4) активное переставление («X изучает Y» вместо «Y изучается X»). Главное — звучание естественно на русском. В заголовках и методах русский предпочитает «исследуется», «рассматривается».",
                    examples: "«The error is reduced by 20%» → «Ошибка уменьшается на 20%» (возвратное). «It was found that...» → «Обнаружено, что...» (неопределённо-личное)."
                ),
                StudyQuestion(
                    question: "Герундий, инфинитив, participle — как различать и переводить.",
                    answer: "Gerund (V-ing, существительное): «Training the model takes hours» → «Обучение модели занимает часы». Infinitive (to V): «to train the model» → «обучить модель». Participle I (V-ing, прилагательное): «training data» → «обучающие данные». Participle II (V-ed): «trained model» → «обученная модель». Распространённая ловушка: «used to» = «раньше делали» (past habit); «is used to» = «используется для» (пассив); «is used to doing» = «привык делать».",
                    examples: "«Using deep learning, researchers achieved...» → «Используя глубокое обучение, исследователи достигли...»"
                ),
                StudyQuestion(
                    question: "Ложные друзья переводчика в научных текстах.",
                    answer: "В научной лексике много «false friends»: actual ≠ «актуальный», а «фактический»; accurate ≠ «аккуратный», а «точный»; complex ≠ «комплексный», а «сложный»; significant ≠ «значительный» (в статистике — «значимый»); novel ≠ «новелла», а «новый»; matter ≠ «материя», а «вопрос/иметь значение»; sensible ≠ «сенсибельный», а «разумный»; genial ≠ «гениальный», а «приветливый».",
                    examples: "«The results are statistically significant» = «Результаты статистически значимы», а не «значительны». Для «значительный» в широком смысле — «substantial», «considerable»."
                ),
                StudyQuestion(
                    question: "Как переводить термины специальности?",
                    answer: "1) Устоявшиеся — использовать русский эквивалент (neural network = нейронная сеть, database = база данных). 2) Новые/узкоспециальные — если есть принятый термин в русскоязычной литературе — использовать его; если нет — транслитерация или калька с пояснением в скобках. 3) Аббревиатуры: общепринятые (IoT, ML, API) часто оставляют латиницей; малоизвестные — расшифровка + транслитерация. 4) В сомнениях — консультироваться со словарём специальности (ВАК, ГОСТ).",
                    examples: "«attention mechanism» — устоявшееся «механизм внимания». «Transformer» в ML — «трансформер» (калька), часто оставляется латиницей."
                )
            ]
        )
    }

    static var oralPart: StudyTopic {
        StudyTopic(
            title: "Устная часть и собеседование",
            summary: "Типовые вопросы, полезные фразы, стратегии.",
            questions: [
                StudyQuestion(
                    question: "Какие вопросы чаще всего задают на устной части?",
                    answer: "Стандартный набор: 1) Tell us about yourself / your education. 2) Why did you choose this university/program? 3) What is your research area/PhD topic? 4) What methods do you plan to use? 5) Why is this problem important? 6) What papers in the field have you read recently? 7) Hypothetical: how would you extend method X? 8) Questions about the read text: main idea, your opinion, open questions. Комиссия оценивает не только язык, но и исследовательскую зрелость.",
                    examples: "Хороший кандидат сможет через 5 минут собеседования упомянуть 2-3 конкретных статьи по теме, назвать методы и ограничения."
                ),
                StudyQuestion(
                    question: "Какие фразы помогут звучать академично?",
                    answer: "Начало: «In my view…», «From my perspective…», «It seems to me that…». Переход: «Moving on to…», «That brings me to…». Согласие с оговоркой: «To some extent, I agree, but…», «That's a fair point; however…». Признание незнания: «I'm not entirely sure, but I would guess…», «That's an interesting question; I'd need to think more about it». Summary: «So, to summarise…», «In conclusion…».",
                    examples: "Вместо «I don't know» — «That's outside my area of expertise, but I could speculate that…» Звучит сильнее и показывает критическое мышление."
                ),
                StudyQuestion(
                    question: "Как вести себя, если не понял вопрос?",
                    answer: "1) Попросите перефразировать: «Could you rephrase the question?» / «I'm not sure I understood — could you elaborate?». 2) Повторите своими словами для проверки: «If I understand correctly, you're asking whether X…». 3) Дайте себе время: «That's a good question, let me think for a moment». Не изображайте понимание — комиссия видит. Честное уточнение — признак зрелости.",
                    examples: "Плохо: отвечать мимо вопроса. Хорошо: «Before I answer, I want to make sure — are you asking about the theoretical or the practical aspect?»"
                ),
                StudyQuestion(
                    question: "Как рассказывать о будущей диссертации?",
                    answer: "Структура (2-3 минуты): 1) Название и область (1 предложение). 2) Проблема/гэп в существующих работах (2 предложения). 3) Ваш предлагаемый подход (2-3 предложения). 4) Ожидаемый вклад / применения (1-2 предложения). Не углубляйтесь в детали, пока не спросят. Оставьте «крючки» для вопросов, чтобы управлять разговором.",
                    examples: "«My PhD focuses on [area]. Existing methods [problem]. I plan to [approach]. This could [contribution]. One open question I find particularly interesting is [hook].»"
                ),
                StudyQuestion(
                    question: "Произношение терминов — что типично вызывает сложности?",
                    answer: "Частые ошибки: algorithm /ˈæl.ɡə.rɪ.ðəm/ (не al-go-RITHM), hypothesis /haɪˈpɒθ.ə.sɪs/, parameter /pəˈræm.ɪ.tər/, analysis /əˈnæl.ə.sɪs/, hierarchy /ˈhaɪ.ə.rɑːr.ki/, data можно /ˈdeɪ.tə/ или /ˈdæt.ə/. Ударение часто на неожиданном слоге в латинизмах. Проверяйте Cambridge Dictionary (есть аудио).",
                    examples: "«Ubiquitous» /juːˈbɪk.wɪ.təs/, «paradigm» /ˈpær.ə.daɪm/, «Gaussian» /ˈɡaʊ.si.ən/ (не ga-USS-i-an)."
                )
            ]
        )
    }

    static var commonMistakes: StudyTopic {
        StudyTopic(
            title: "Типовые ошибки и лайфхаки",
            summary: "Артикли, времена, предлоги — что проверяется особенно придирчиво.",
            questions: [
                StudyQuestion(
                    question: "Правила артиклей для научного текста.",
                    answer: "The — когда объект уникален или уже упомянут («the method», «the same dataset»). A/An — первое упоминание исчисляемого. Без артикля — абстрактные/неисчисляемые («research», «information»). В названиях статей и методов артикли часто опускают: «Transformer architecture», «BERT model». Перед общеизвестными: «the Sun», «the Internet», «the GDP».",
                    examples: "«We propose a new approach [первое упоминание]. The approach [теперь определённое] consists of…»"
                ),
                StudyQuestion(
                    question: "Когда использовать Present Perfect vs Past Simple?",
                    answer: "Past Simple — законченное действие в прошлом с конкретным моментом: «In 2022, we published…», «Smith (2020) proposed…». Present Perfect — действие, связанное с настоящим: «Recent work has shown…», «Several approaches have been proposed». В научных статьях обзор литературы часто в Present Perfect, конкретные эксперименты — в Past Simple.",
                    examples: "«Much research *has been* done on X [общее состояние]. Last year, Bob *studied* Y [конкретное исследование].»"
                ),
                StudyQuestion(
                    question: "Типовые предложные ошибки.",
                    answer: "Depend ON (не from), consist OF (не from), differ FROM (не with), result IN (не to), at/in/on: at a conference, in a paper, on a topic, for — цель, by — способ/автор. Important FOR vs important TO: depend on context. Interested IN something. Specialize IN. Based ON. In comparison WITH. Contrary TO. In accordance WITH.",
                    examples: "Правильно: «The results *depend on* the hyperparameters.» Неправильно: «The results depend *from* the hyperparameters.» (калька с русского)"
                ),
                StudyQuestion(
                    question: "Согласование времён и условные предложения.",
                    answer: "Согласование времён: если главная клауза в прошедшем, то придаточная сдвигает время на шаг назад (kind reported rule; но для постоянных фактов/универсальных истин — не сдвигается). Conditionals: 0 — общие истины (If you heat water, it boils); 1 — реальные будущие (If we increase lr, training will fail); 2 — нереальные настоящие (If I had time, I would read); 3 — нереальные прошлые (If we had known, we would have tried).",
                    examples: "«He said that the Earth is flat» — оставляем is, если речь об общем убеждении, или ставим was, если о его конкретном утверждении в прошлом (dependent on emphasis)."
                ),
                StudyQuestion(
                    question: "Какие универсальные лайфхаки сэкономят вам баллы?",
                    answer: "1) Всегда перечитывайте перевод/ответ на предмет артиклей и предлогов — частый источник потерь. 2) Не используйте идиомы, которые вы не уверены на 100% (лучше простое правильное, чем красивое с ошибкой). 3) Избегайте длинных словарных форм, если не уверены — утилизируйте. 4) Не бойтесь переформулировать на простом английском («to put it simply»). 5) Делайте паузу перед ответом, а не заполняйте её «эээ».",
                    examples: "Вместо невнятной конструкции лучше: «Let me rephrase — in simple terms, X leads to Y because Z.»"
                )
            ]
        )
    }
}
