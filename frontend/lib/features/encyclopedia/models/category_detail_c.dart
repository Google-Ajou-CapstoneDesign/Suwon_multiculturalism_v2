import '../../../core/app_language.dart';
import 'category_detail.dart';

const Map<int, CategoryDetail> categoryDetailDataC = {
  9: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '근로계약서를 반드시 써야 하는 이유',
          en: 'Why You Must Have a Written Employment Contract',
          zh: '为什么必须签订劳动合同',
          vi: 'Lý do phải lập hợp đồng lao động bằng văn bản',
        ),
        summary: L10nText(
          ko: '근로기준법 제17조에 따라 사업주는 핵심 근로조건을 서면으로 작성해 근로자에게 교부할 의무가 있으며, 상시근로자 5인 미만 사업장에도 이 의무는 그대로 적용됩니다.',
          en: 'Under Article 17 of the Labor Standards Act, employers must put key working conditions in writing and give a copy to the employee. This obligation applies even to workplaces with fewer than 5 regular employees.',
          zh: '根据《劳动基准法》第17条，雇主有义务将核心劳动条件以书面形式制作并交付给劳动者，即使是经常雇用不满5人的事业场，这一义务同样适用。',
          vi: 'Theo Điều 17 Luật Tiêu chuẩn Lao động, người sử dụng lao động có nghĩa vụ lập bằng văn bản các điều kiện lao động chính và giao cho người lao động; nghĩa vụ này vẫn được áp dụng ngay cả với nơi làm việc thường xuyên có dưới 5 lao động.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '법적 근거',
              en: 'Legal Basis',
              zh: '法律依据',
              vi: 'Căn cứ pháp lý',
            ),
            bullets: [
              L10nText(
                ko: '근로기준법 제17조: 임금 구성·계산·지급방법 등 핵심 근로조건을 서면으로 명시해 교부해야 합니다.',
                en: 'Labor Standards Act Article 17: Key working conditions such as wage composition, calculation, and payment method must be specified in writing and delivered to the employee.',
                zh: '《劳动基准法》第17条：工资构成、计算及支付方式等核心劳动条件必须以书面形式明确并交付。',
                vi: 'Điều 17 Luật Tiêu chuẩn Lao động: Phải ghi rõ bằng văn bản và giao cho người lao động các điều kiện lao động chính như cơ cấu, cách tính và phương thức trả lương.',
              ),
              L10nText(
                ko: '위반 시 500만 원 이하 벌금(형사처벌) 대상입니다.',
                en: 'Violations are subject to a criminal fine of up to KRW 5 million.',
                zh: '违反规定将被处以500万韩元以下罚款（刑事处罚）。',
                vi: 'Nếu vi phạm sẽ bị phạt tiền tối đa 5 triệu won (xử lý hình sự).',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '나중을 위한 가장 강한 증거',
              en: 'Your Strongest Evidence for Later',
              zh: '日后维权最有力的证据',
              vi: 'Bằng chứng mạnh nhất cho sau này',
            ),
            bullets: [
              L10nText(
                ko: '임금체불(⑩)·산업재해(⑪) 신청 시 근로계약서와 임금명세서가 가장 강한 법적 증거로 인정됩니다.',
                en: 'When filing an unpaid wages claim (⑩) or an industrial accident claim (⑪), the employment contract and pay stub are recognized as the strongest legal evidence.',
                zh: '在申请拖欠工资（⑩）或工伤（⑪）时，劳动合同和工资明细单被认定为最有力的法律证据。',
                vi: 'Khi nộp đơn khiếu nại nợ lương (⑩) hoặc tai nạn lao động (⑪), hợp đồng lao động và bảng lương được công nhận là bằng chứng pháp lý mạnh nhất.',
              ),
              L10nText(
                ko: '계약서를 받으면 사진으로 백업해두고, 원본은 별도 보관하세요.',
                en: 'Once you receive the contract, take a photo of it for backup and keep the original in a separate safe place.',
                zh: '收到合同后请拍照备份，并将原件另行妥善保管。',
                vi: 'Sau khi nhận được hợp đồng, hãy chụp ảnh lưu lại và bảo quản bản gốc ở nơi riêng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '근로계약서 vs 취업규칙',
              en: 'Employment Contract vs. Workplace Rules',
              zh: '劳动合同 vs 就业规则',
              vi: 'Hợp đồng lao động và Nội quy lao động',
            ),
            bullets: [
              L10nText(
                ko: '근로계약서는 개인별 계약이고, 취업규칙은 사업장 공통 규정입니다.',
                en: 'An employment contract is an individual agreement, while workplace rules are common regulations that apply to the whole workplace.',
                zh: '劳动合同是与个人签订的合同，就业规则是适用于整个事业场的统一规定。',
                vi: 'Hợp đồng lao động là thỏa thuận riêng với từng cá nhân, còn nội quy lao động là quy định chung áp dụng cho toàn bộ nơi làm việc.',
              ),
              L10nText(
                ko: '두 내용이 다르면 근로자에게 더 유리한 조건이 우선 적용됩니다.',
                en: 'If the two differ, whichever condition is more favorable to the employee takes priority.',
                zh: '若两者内容不一致，以对劳动者更有利的条件优先适用。',
                vi: 'Nếu hai nội dung khác nhau, điều kiện có lợi hơn cho người lao động sẽ được ưu tiên áp dụng.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '표준근로계약서 필수 기재 5대 항목',
          en: 'The 5 Required Items in a Standard Employment Contract',
          zh: '标准劳动合同必须记载的五大事项',
          vi: '5 hạng mục bắt buộc trong hợp đồng lao động chuẩn',
        ),
        summary: L10nText(
          ko: '고용노동부는 업종·고용형태별 표준근로계약서 서식을 무료로 제공하며, 아래 5개 항목은 반드시 구체적으로 적혀 있어야 합니다.',
          en: 'The Ministry of Employment and Labor provides standard employment contract forms free of charge by industry and employment type. The 5 items below must always be specifically stated.',
          zh: '雇佣劳动部按行业和雇佣形态免费提供标准劳动合同范本，以下五项内容必须具体载明。',
          vi: 'Bộ Việc làm và Lao động cung cấp miễn phí mẫu hợp đồng lao động chuẩn theo ngành nghề và hình thức tuyển dụng, 5 hạng mục dưới đây bắt buộc phải được ghi cụ thể.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '확인할 5대 항목',
              en: 'The 5 Items to Check',
              zh: '需确认的五大事项',
              vi: '5 hạng mục cần kiểm tra',
            ),
            bullets: [
              L10nText(
                ko: '임금: 기본급, 각종 수당의 구성항목·계산방법·지급방법·지급일',
                en: 'Wages: base pay, and the composition, calculation method, payment method, and payday of each allowance',
                zh: '工资：基本工资及各类津贴的构成项目、计算方法、支付方式和支付日',
                vi: 'Tiền lương: lương cơ bản, các khoản mục cấu thành, cách tính, phương thức và ngày trả các loại phụ cấp',
              ),
              L10nText(
                ko: '근로시간: 시업·종업 시각, 휴게시간',
                en: 'Working hours: start and end times, break time',
                zh: '工作时间：上下班时间、休息时间',
                vi: 'Thời gian làm việc: giờ bắt đầu, giờ kết thúc, thời gian nghỉ giải lao',
              ),
              L10nText(
                ko: '휴일: 주휴일, 법정공휴일 적용 여부',
                en: 'Holidays: weekly paid day off, whether statutory public holidays apply',
                zh: '休息日：每周休息日、法定公休日适用与否',
                vi: 'Ngày nghỉ: ngày nghỉ hằng tuần có lương, có áp dụng ngày lễ pháp định hay không',
              ),
              L10nText(
                ko: '연차유급휴가',
                en: 'Annual paid leave',
                zh: '带薪年假',
                vi: 'Nghỉ phép năm có lương',
              ),
              L10nText(
                ko: '취업 장소와 담당 업무',
                en: 'Place of work and job duties',
                zh: '工作地点和担任业务',
                vi: 'Địa điểm làm việc và công việc phụ trách',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '서식 구하는 곳',
              en: 'Where to Get the Form',
              zh: '获取合同范本的途径',
              vi: 'Nơi lấy mẫu hợp đồng',
            ),
            bullets: [
              L10nText(
                ko: '고용노동부 홈페이지(moel.go.kr)에서 업종별 표준근로계약서(7종) 무료 다운로드',
                en: 'Free download of 7 types of standard employment contracts by industry from the Ministry of Employment and Labor website (moel.go.kr)',
                zh: '可在雇佣劳动部官网（moel.go.kr）免费下载各行业标准劳动合同（共7种）',
                vi: 'Tải miễn phí 7 loại hợp đồng lao động chuẩn theo ngành nghề tại trang web Bộ Việc làm và Lao động (moel.go.kr)',
              ),
              L10nText(
                ko: 'E-9 근로자는 본인 언어로 병기된 고용허가제 표준근로계약서를 사용합니다.',
                en: 'E-9 workers use the standard Employment Permit System contract, which is written bilingually in their own language alongside Korean.',
                zh: 'E-9劳动者使用附有本国语言对照的雇佣许可制标准劳动合同。',
                vi: 'Lao động diện E-9 sử dụng hợp đồng lao động chuẩn theo Chế độ Cấp phép Việc làm được ghi song ngữ bằng tiếng mẹ đẻ.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '2026년 최저임금',
              en: '2026 Minimum Wage',
              zh: '2026年最低工资',
              vi: 'Lương tối thiểu năm 2026',
            ),
            bullets: [
              L10nText(
                ko: '2026년 적용 최저임금은 시간급 10,320원입니다(고용노동부 고시, 매년 변동).',
                en: 'The minimum wage applicable in 2026 is KRW 10,320 per hour (announced by the Ministry of Employment and Labor; changes every year).',
                zh: '2026年适用的最低工资为每小时10,320韩元（雇佣劳动部公告，每年变动）。',
                vi: 'Lương tối thiểu áp dụng năm 2026 là 10.320 won/giờ (do Bộ Việc làm và Lao động công bố, thay đổi hằng năm).',
              ),
              L10nText(
                ko: '최저임금에 미달하는 계약은 그 부분만 무효가 되고 최저임금 기준으로 대체됩니다.',
                en: 'If a contract specifies pay below the minimum wage, only that part becomes invalid and is replaced by the minimum wage standard.',
                zh: '低于最低工资标准的合同条款，该部分无效，并以最低工资标准替代。',
                vi: 'Nếu hợp đồng quy định mức lương thấp hơn lương tối thiểu, chỉ phần đó bị vô hiệu và được thay thế bằng mức lương tối thiểu.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '3.3% 사업소득세, 위장 프리랜서 방어',
          en: '3.3% Business Income Tax and Defending Against Disguised Freelance Work',
          zh: '3.3%事业所得税与防范"伪装自由职业"',
          vi: 'Thuế thu nhập kinh doanh 3.3% và cách đối phó với "freelancer trá hình"',
        ),
        summary: L10nText(
          ko: '계약서 제목이 "용역계약서"이고 3.3%를 공제하더라도, 실제로 사업주의 지시를 받아 정해진 시간·장소에서 일했다면 근로기준법상 근로자로 인정될 수 있습니다.',
          en: 'Even if your contract is titled a "service contract" and 3.3% is withheld from your pay, you may still be recognized as an employee under the Labor Standards Act if you actually worked under the employer\'s direction at a fixed time and place.',
          zh: '即使合同名称为"劳务合同"并被扣除3.3%的税款，只要实际上是接受雇主指示、在固定时间和地点工作的，仍可能被认定为《劳动基准法》上的劳动者。',
          vi: 'Dù hợp đồng có tên là "hợp đồng dịch vụ" và bị khấu trừ 3.3%, nếu thực tế bạn làm việc theo sự chỉ đạo của người sử dụng lao động, tại thời gian và địa điểm cố định, bạn vẫn có thể được công nhận là người lao động theo Luật Tiêu chuẩn Lao động.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '판단 기준(대법원)',
              en: 'Criteria for Judgment (Supreme Court)',
              zh: '判断标准（最高法院）',
              vi: 'Tiêu chí xác định (Tòa án Tối cao)',
            ),
            bullets: [
              L10nText(
                ko: '계약의 형식이 아니라 실질을 봅니다: 출퇴근 시간이 정해져 있었는지, 업무 내용을 사업주가 지시했는지, 정해진 장소에서 근무했는지, 매월 일정 금액을 받았는지',
                en: 'What matters is the substance of the work, not the form of the contract: whether working hours were fixed, whether the employer directed the work content, whether you worked at a fixed location, and whether you received a fixed amount each month',
                zh: '判断的关键在于实质而非合同形式：上下班时间是否固定、工作内容是否由雇主指示、是否在固定地点工作、是否每月领取固定金额',
                vi: 'Điều quan trọng là bản chất công việc chứ không phải hình thức hợp đồng: giờ đi làm/tan làm có cố định không, nội dung công việc có do người sử dụng lao động chỉ đạo không, có làm việc tại địa điểm cố định không, có nhận một khoản tiền cố định hằng tháng không',
              ),
              L10nText(
                ko: '3.3% 원천징수, 4대보험 미가입 자체는 근로자성 판단에 거의 영향을 주지 않습니다.',
                en: 'The fact that 3.3% was withheld or that you were not enrolled in the four major social insurances has little effect on whether you are judged to be an employee.',
                zh: '被扣缴3.3%税款或未加入四大社会保险，本身对是否认定为劳动者几乎没有影响。',
                vi: 'Việc bị khấu trừ 3.3% hay không tham gia 4 loại bảo hiểm xã hội bắt buộc hầu như không ảnh hưởng đến việc xác định tư cách người lao động.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '근로자로 인정되면 달라지는 것',
              en: 'What Changes If You Are Recognized as an Employee',
              zh: '被认定为劳动者后会有哪些变化',
              vi: 'Điều gì thay đổi nếu được công nhận là người lao động',
            ),
            bullets: [
              L10nText(
                ko: '최저임금, 연장·야간·휴일수당, 퇴직금, 4대보험 적용 대상이 됩니다.',
                en: 'You become entitled to the minimum wage, overtime/night/holiday allowances, severance pay, and the four major social insurances.',
                zh: '将适用最低工资、加班·夜间·休息日津贴、退职金以及四大社会保险。',
                vi: 'Bạn sẽ được áp dụng lương tối thiểu, phụ cấp làm thêm giờ/làm đêm/ngày nghỉ, trợ cấp thôi việc và 4 loại bảo hiểm xã hội bắt buộc.',
              ),
              L10nText(
                ko: '의심되면 근로계약서·업무지시 메시지·출퇴근 기록을 모아 고용노동부 진정 또는 상담기관에 문의하세요.',
                en: 'If you suspect this applies to you, gather your employment contract, work-instruction messages, and attendance records, then file a petition with the Ministry of Employment and Labor or contact a counseling organization.',
                zh: '如有疑问，请收集劳动合同、工作指示消息、上下班记录，向雇佣劳动部提出陈情或咨询相关咨询机构。',
                vi: 'Nếu nghi ngờ, hãy thu thập hợp đồng lao động, tin nhắn chỉ đạo công việc, hồ sơ đi làm/tan làm rồi nộp đơn khiếu nại lên Bộ Việc làm và Lao động hoặc liên hệ cơ quan tư vấn.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '근로자성이 인정되면 소급 청구 가능',
              en: 'If Employee Status Is Recognized, You Can Claim Retroactively',
              zh: '一旦被认定具有劳动者身份，可追溯请求补偿',
              vi: 'Nếu được công nhận tư cách người lao động, có thể yêu cầu truy lĩnh',
            ),
            bullets: [
              L10nText(
                ko: '근로자로 인정되면 그동안 받지 못한 4대보험, 연장·야간·휴일수당, 퇴직금을 소급해서 청구할 수 있습니다.',
                en: 'Once recognized as an employee, you can retroactively claim the four major social insurances, overtime/night/holiday allowances, and severance pay that you did not receive.',
                zh: '一旦被认定为劳动者，可以追溯请求此前未获得的四大社会保险、加班·夜间·休息日津贴及退职金。',
                vi: 'Khi được công nhận là người lao động, bạn có thể yêu cầu truy lĩnh 4 loại bảo hiểm xã hội, phụ cấp làm thêm giờ/làm đêm/ngày nghỉ và trợ cấp thôi việc mà trước đây chưa nhận được.',
              ),
              L10nText(
                ko: '소급 청구도 임금채권 소멸시효 3년 이내에서만 가능합니다.',
                en: 'Retroactive claims are also only possible within the 3-year statute of limitations for wage claims.',
                zh: '追溯请求同样只能在工资债权3年的消灭时效内提出。',
                vi: 'Việc yêu cầu truy lĩnh cũng chỉ có thể thực hiện trong thời hiệu 3 năm của quyền yêu cầu tiền lương.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '독소조항 체크리스트',
          en: 'Checklist of Toxic Contract Clauses',
          zh: '不利条款核查清单',
          vi: 'Danh sách kiểm tra các điều khoản bất lợi',
        ),
        summary: L10nText(
          ko: '계약서에 아래와 같은 문구가 있다면 근로기준법 위반으로 무효일 가능성이 높으므로, 서명 전 반드시 확인해야 합니다.',
          en: 'If your contract contains any of the clauses below, it is likely invalid as a violation of the Labor Standards Act, so be sure to check before signing.',
          zh: '如果合同中含有以下内容，很可能因违反《劳动基准法》而无效，签字前请务必确认。',
          vi: 'Nếu hợp đồng có các điều khoản như dưới đây, khả năng cao là vô hiệu do vi phạm Luật Tiêu chuẩn Lao động, vì vậy hãy chắc chắn kiểm tra trước khi ký.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '무효가 될 수 있는 조항',
              en: 'Clauses That May Be Invalid',
              zh: '可能无效的条款',
              vi: 'Các điều khoản có thể bị vô hiệu',
            ),
            bullets: [
              L10nText(
                ko: '"계약 위반 시 위약금 000만 원" 같은 위약금·손해배상액 예정 조항 (근로기준법 제20조 위반, 위반 시 사업주 500만 원 이하 벌금)',
                en: 'Predetermined penalty or damages clauses such as "a penalty of KRW 000万 for breach of contract" (violates Labor Standards Act Article 20; employer is subject to a fine of up to KRW 5 million)',
                zh: '"违反合同时支付违约金000万韩元"等预先约定违约金或损害赔偿金的条款（违反《劳动基准法》第20条，雇主将被处以500万韩元以下罚款）',
                vi: 'Điều khoản ấn định trước tiền phạt vi phạm hoặc bồi thường thiệt hại như "vi phạm hợp đồng phạt 000 vạn won" (vi phạm Điều 20 Luật Tiêu chuẩn Lao động, người sử dụng lao động bị phạt tối đa 5 triệu won)',
              ),
              L10nText(
                ko: '"숙식비로 급여의 절반 공제" 등 근거 없이 과도한 숙식비 공제',
                en: 'Excessive, unjustified deductions for room and board, such as "half of your pay deducted for room and board"',
                zh: '"以食宿费名义扣除工资一半"等缺乏依据的过度食宿费扣除',
                vi: 'Khấu trừ tiền ăn ở quá mức không có căn cứ, chẳng hạn "khấu trừ một nửa lương làm tiền ăn ở"',
              ),
              L10nText(
                ko: '연장·야간·휴일근로 수당을 기본급에 포함해 별도로 계산하지 않는 포괄임금 조항',
                en: 'A "comprehensive wage" clause that folds overtime, night, and holiday allowances into the base pay instead of calculating them separately',
                zh: '将加班、夜间、休息日津贴包含在基本工资内、不单独计算的"包干工资"条款',
                vi: 'Điều khoản "lương trọn gói" gộp phụ cấp làm thêm giờ/làm đêm/ngày nghỉ vào lương cơ bản mà không tính riêng',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '5인 미만 사업장은 예외',
              en: 'Workplaces with Fewer Than 5 Employees Are an Exception',
              zh: '不满5人的事业场为例外',
              vi: 'Trường hợp ngoại lệ: nơi làm việc dưới 5 lao động',
            ),
            bullets: [
              L10nText(
                ko: '근로기준법의 가산임금(1.5배) 규정은 상시근로자 5인 이상 사업장에만 적용됩니다.',
                en: 'The Labor Standards Act\'s premium wage rule (1.5x pay) only applies to workplaces with 5 or more regular employees.',
                zh: '《劳动基准法》规定的加成工资（1.5倍）仅适用于经常雇用5人以上的事业场。',
                vi: 'Quy định về tiền lương tính thêm (1.5 lần) trong Luật Tiêu chuẩn Lao động chỉ áp dụng cho nơi làm việc thường xuyên có từ 5 lao động trở lên.',
              ),
              L10nText(
                ko: '5인 미만 사업장은 연장·야간·휴일근로를 해도 1.5배가 아닌 1.0배만 받을 수 있으며, 인원수는 임금명세서나 4대보험 가입자 수로 확인할 수 있습니다.',
                en: 'At workplaces with fewer than 5 employees, you receive only 1.0x pay (not 1.5x) even for overtime, night, or holiday work. You can check the employee count via pay stubs or the number enrolled in the four major social insurances.',
                zh: '在不满5人的事业场，即使加班、夜间或休息日工作，也只能领取1.0倍而非1.5倍的工资；员工人数可通过工资明细单或四大社会保险参保人数确认。',
                vi: 'Tại nơi làm việc dưới 5 lao động, dù làm thêm giờ, làm đêm hay làm ngày nghỉ cũng chỉ được trả 1.0 lần chứ không phải 1.5 lần; có thể xác nhận số lượng lao động qua bảng lương hoặc số người tham gia 4 loại bảo hiểm xã hội.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '수습기간 감액의 3가지 조건',
              en: 'Three Conditions for Reducing Pay During a Probation Period',
              zh: '试用期减薪的三个条件',
              vi: 'Ba điều kiện để giảm lương trong thời gian thử việc',
            ),
            bullets: [
              L10nText(
                ko: '근로계약 기간 1년 이상, 수습 시작 후 3개월 이내, 단순노무직이 아닐 것 — 세 조건을 모두 충족해야 최저임금의 90%까지만 감액할 수 있습니다.',
                en: 'A contract term of 1 year or more, within 3 months of starting probation, and not a simple labor job — only when all three conditions are met can pay be reduced to as low as 90% of the minimum wage.',
                zh: '劳动合同期限1年以上、试用开始后3个月以内、非简单劳务岗位——须同时满足这三个条件，才能将工资减至最低工资的90%。',
                vi: 'Thời hạn hợp đồng lao động từ 1 năm trở lên, trong vòng 3 tháng kể từ khi bắt đầu thử việc, không phải công việc lao động giản đơn — phải đáp ứng đủ cả ba điều kiện thì mới được giảm lương tối đa xuống còn 90% lương tối thiểu.',
              ),
              L10nText(
                ko: '하나라도 충족하지 못하면 수습 중에도 최저임금 100%를 받아야 합니다.',
                en: 'If even one condition is not met, you must be paid 100% of the minimum wage even during probation.',
                zh: '只要有一个条件不满足，即使在试用期也必须领取100%的最低工资。',
                vi: 'Nếu không đáp ứng dù chỉ một điều kiện, bạn phải được trả đủ 100% lương tối thiểu ngay cả trong thời gian thử việc.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '근로계약서를 못 받았을 때 대응',
          en: 'What to Do If You Never Received a Written Contract',
          zh: '未收到劳动合同时的应对方法',
          vi: 'Cách xử lý khi không nhận được hợp đồng lao động',
        ),
        summary: L10nText(
          ko: '계약서를 안 써줬다고 근로관계 자체가 부정되는 것은 아니며, 다른 자료로 얼마든지 근무 사실과 약정 내용을 입증할 수 있습니다.',
          en: 'Not being given a written contract does not negate the existence of an employment relationship. You can still prove that you worked and what was agreed using other evidence.',
          zh: '未签订书面合同并不意味着劳动关系不成立，仍可通过其他资料证明工作事实和约定内容。',
          vi: 'Việc không được lập hợp đồng bằng văn bản không có nghĩa là quan hệ lao động bị phủ nhận; bạn hoàn toàn có thể chứng minh việc làm việc thực tế và nội dung thỏa thuận bằng các tài liệu khác.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '대체 증거 모으기',
              en: 'Gathering Alternative Evidence',
              zh: '收集替代证据',
              vi: 'Thu thập bằng chứng thay thế',
            ),
            bullets: [
              L10nText(
                ko: '임금명세서, 통장 입금 내역, 업무지시 문자·카카오톡, 출퇴근 기록(교통카드, GPS)',
                en: 'Pay stubs, bank deposit records, work-instruction texts/KakaoTalk messages, attendance records (transit card, GPS)',
                zh: '工资明细单、银行入账记录、工作指示短信/KakaoTalk消息、上下班记录（交通卡、GPS）',
                vi: 'Bảng lương, sao kê tiền lương chuyển vào tài khoản, tin nhắn/KakaoTalk chỉ đạo công việc, hồ sơ đi làm/tan làm (thẻ giao thông, GPS)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '요청 및 신고',
              en: 'Requesting and Reporting',
              zh: '要求与举报',
              vi: 'Yêu cầu và trình báo',
            ),
            bullets: [
              L10nText(
                ko: '사업주에게 서면 교부를 문자로 정식 요청하고, 요청 사실 자체를 증거로 남기세요.',
                en: 'Formally request the written contract from your employer by text message, and keep the request itself as evidence.',
                zh: '通过短信正式向雇主提出书面合同交付要求，并将该要求本身留存为证据。',
                vi: 'Gửi tin nhắn chính thức yêu cầu người sử dụng lao động giao hợp đồng bằng văn bản, và giữ lại chính yêu cầu đó làm bằng chứng.',
              ),
              L10nText(
                ko: '계속 거부하면 고용노동부에 근로계약서 미교부로 별도 진정이 가능합니다.',
                en: 'If the employer continues to refuse, you can file a separate petition with the Ministry of Employment and Labor for failure to provide a written contract.',
                zh: '若雇主持续拒绝，可就未交付劳动合同一事单独向雇佣劳动部提出陈情。',
                vi: 'Nếu người sử dụng lao động tiếp tục từ chối, bạn có thể nộp đơn khiếu nại riêng lên Bộ Việc làm và Lao động về việc không giao hợp đồng lao động.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '고용노동부 진정 외 방법',
              en: 'Options Besides Filing a Petition with the Ministry',
              zh: '除向雇佣劳动部陈情外的其他方法',
              vi: 'Các cách khác ngoài việc khiếu nại lên Bộ Việc làm và Lao động',
            ),
            bullets: [
              L10nText(
                ko: '사업장 관할 고용센터, 노무사 상담, ⑫상담기관에서도 도움을 받을 수 있습니다.',
                en: 'You can also get help from the employment center with jurisdiction over your workplace, a certified labor consultant, or a ⑫counseling organization.',
                zh: '也可以向管辖该事业场的就业中心、劳务士咨询或⑫咨询机构寻求帮助。',
                vi: 'Bạn cũng có thể nhận hỗ trợ từ trung tâm việc làm quản lý nơi làm việc, tư vấn luật sư lao động, hoặc ⑫cơ quan tư vấn.',
              ),
              L10nText(
                ko: '계약서 미교부가 반복되는 사업장이라면 동료들과 함께 증거를 모아두는 것도 방법입니다.',
                en: 'If a workplace repeatedly fails to provide contracts, it can also help to gather evidence together with your coworkers.',
                zh: '如果该事业场屡次不交付合同，与同事一起收集证据也是一种方法。',
                vi: 'Nếu nơi làm việc thường xuyên không giao hợp đồng, việc cùng đồng nghiệp thu thập bằng chứng cũng là một cách hữu ích.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  10: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '1단계: 체불액 정리와 증거 수집',
          en: 'Step 1: Organizing the Unpaid Amount and Collecting Evidence',
          zh: '第一步：整理拖欠金额并收集证据',
          vi: 'Bước 1: Tổng hợp số tiền bị nợ và thu thập bằng chứng',
        ),
        summary: L10nText(
          ko: '근무기록·통장 거래내역·근로계약서를 대조해 미지급 금액과 증거를 모으는 단계로, 기본급뿐 아니라 주휴수당·연장수당·연차수당·퇴직금까지 빠짐없이 계산하는 것이 핵심입니다.',
          en: 'This is the stage where you cross-check your work records, bank statements, and employment contract to gather the unpaid amount and evidence. The key is to calculate everything without omission — not just base pay, but also the weekly holiday allowance, overtime allowance, annual leave allowance, and severance pay.',
          zh: '这一步是对照工作记录、银行交易明细和劳动合同，整理未支付金额和证据的阶段。关键在于不仅要计算基本工资，还要毫无遗漏地计算周休津贴、加班津贴、年假津贴和退职金。',
          vi: 'Đây là giai đoạn đối chiếu hồ sơ làm việc, sao kê tài khoản ngân hàng và hợp đồng lao động để tổng hợp số tiền chưa được trả và bằng chứng. Điểm mấu chốt là phải tính đầy đủ không chỉ lương cơ bản mà cả phụ cấp nghỉ hằng tuần, phụ cấp làm thêm giờ, phụ cấp nghỉ phép năm và trợ cấp thôi việc.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '근로계약서, 급여 통장 거래내역서, 임금명세서, 출퇴근 기록',
                en: 'Employment contract, salary account transaction statement, pay stub, attendance record',
                zh: '劳动合同、工资账户交易明细单、工资明细单、上下班记录',
                vi: 'Hợp đồng lao động, sao kê giao dịch tài khoản nhận lương, bảng lương, hồ sơ đi làm/tan làm',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '임금채권 소멸시효는 3년입니다.',
                en: 'The statute of limitations for wage claims is 3 years.',
                zh: '工资债权的消灭时效为3年。',
                vi: 'Thời hiệu của quyền yêu cầu tiền lương là 3 năm.',
              ),
              L10nText(
                ko: '통장 내역은 화면 캡처보다 은행에서 발급한 거래내역서로 준비하는 것이 객관적입니다.',
                en: 'For bank records, it is more objective to prepare an official transaction statement issued by the bank rather than a screenshot.',
                zh: '相比截图，银行开具的交易明细单更具客观性，建议以此准备账户记录。',
                vi: 'Đối với sao kê tài khoản, nên chuẩn bị bản sao kê giao dịch do ngân hàng cấp thay vì ảnh chụp màn hình để đảm bảo tính khách quan.',
              ),
              L10nText(
                ko: '대화 기록은 필요한 부분만 자르지 말고 앞뒤 맥락을 통째로 보관해야 왜곡되지 않습니다.',
                en: 'Do not crop conversation logs to only the parts you need — keep the full context before and after so the record cannot be seen as distorted.',
                zh: '聊天记录不要只截取需要的部分，应保留前后完整语境，以免被认为断章取义。',
                vi: 'Với tin nhắn trao đổi, không nên chỉ cắt phần cần thiết mà phải lưu giữ toàn bộ ngữ cảnh trước sau để tránh bị hiểu sai lệch.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '소멸시효 계산 팁',
              en: 'Tips for Calculating the Statute of Limitations',
              zh: '消灭时效计算小贴士',
              vi: 'Mẹo tính thời hiệu',
            ),
            bullets: [
              L10nText(
                ko: '임금은 지급일 다음 날부터 3년을 계산하며, 매달 발생한 임금은 각각 별도로 시효가 진행됩니다.',
                en: 'The 3-year period for wages is counted from the day after the payday, and wages arising each month have their own separate statute of limitations.',
                zh: '工资的时效从支付日的次日起计算3年，每月产生的工资各自独立计算时效。',
                vi: 'Thời hiệu 3 năm đối với tiền lương được tính từ ngày hôm sau ngày trả lương, và tiền lương phát sinh mỗi tháng có thời hiệu tính riêng.',
              ),
              L10nText(
                ko: '오래된 체불액이 있다면 가장 먼저 발생한 금액부터 시효가 지나지 않았는지 확인하세요.',
                en: 'If you have older unpaid amounts, check whether the statute of limitations has passed starting with the earliest amount owed.',
                zh: '如果有较早的拖欠款项，请先确认最早产生的金额是否已超过时效期限。',
                vi: 'Nếu có khoản nợ lương từ lâu, hãy kiểm tra xem khoản phát sinh sớm nhất có bị hết thời hiệu hay không.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '2단계: 사업주와 대화',
          en: 'Step 2: Talking with the Employer',
          zh: '第二步：与雇主沟通',
          vi: 'Bước 2: Trao đổi với người sử dụng lao động',
        ),
        summary: L10nText(
          ko: '노동청에 알리기 전 체불 내역을 사업주에게 전달해 원만한 해결을 시도하는 단계이며, 단순 체불은 이 단계에서 끝나는 경우가 많습니다.',
          en: 'This is the stage where you notify the employer of the unpaid amount before reporting to the labor office, in an attempt to resolve things amicably. Simple cases of unpaid wages are often settled at this stage.',
          zh: '这一步是在向劳动厅举报之前，先将拖欠情况告知雇主，尝试友好解决的阶段，简单的欠薪问题往往能在这一阶段得到解决。',
          vi: 'Đây là giai đoạn thông báo cho người sử dụng lao động về khoản nợ lương trước khi báo lên cơ quan lao động, nhằm tìm cách giải quyết ổn thỏa; nhiều trường hợp nợ lương đơn giản kết thúc ngay ở bước này.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 것',
              en: 'What to Prepare',
              zh: '需要准备的内容',
              vi: 'Những gì cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '대화 요청문(문자·카카오톡), 미지급 급여 산출 내역서',
                en: 'A written request for discussion (text message/KakaoTalk), a statement calculating the unpaid wages',
                zh: '沟通请求内容（短信/KakaoTalk）、未付工资计算明细表',
                vi: 'Nội dung đề nghị trao đổi (tin nhắn/KakaoTalk), bảng tính toán số tiền lương chưa được trả',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '돈이 실제로 입금되기 전에는 합의서·취하서에 서명하지 마세요.',
                en: 'Do not sign a settlement agreement or withdrawal letter until the money has actually been deposited.',
                zh: '在款项实际到账之前，请勿签署和解书或撤诉书。',
                vi: 'Không ký vào văn bản thỏa thuận hay đơn rút đơn khiếu nại trước khi tiền thực sự được chuyển vào tài khoản.',
              ),
              L10nText(
                ko: '합의서를 쓴다면 지급 기일과 "세후 실지급액" 기준 금액을 반드시 명시하고, "언제까지 얼마가 입금되면 취하서를 낸다"는 순서로 정하는 것이 안전합니다.',
                en: 'If you do write a settlement agreement, always specify the payment deadline and the amount based on "actual after-tax payment," and it is safer to set the order as "the withdrawal letter is filed only after a specified amount is deposited by a specified date."',
                zh: '如果要签订和解书，必须明确注明支付期限和以"税后实付金额"为准的金额，并按照"在某日期前收到某金额后再提交撤诉书"的顺序约定，这样更安全。',
                vi: 'Nếu lập văn bản thỏa thuận, phải ghi rõ thời hạn thanh toán và số tiền tính theo "số tiền thực nhận sau thuế", đồng thời nên quy định theo trình tự an toàn là "chỉ nộp đơn rút đơn sau khi nhận đủ số tiền quy định trước một thời hạn nhất định".',
              ),
              L10nText(
                ko: '임금체불은 반의사불벌죄이므로, 돈을 받기 전에 처벌불원 취하서에 서명하면 이후 사업주가 약속을 어겨도 다시 진정할 수 없습니다.',
                en: 'Because unpaid wages is a crime prosecuted only upon complaint, if you sign a letter stating you do not wish to press charges before receiving the money, you cannot file another petition even if the employer later breaks the promise.',
                zh: '拖欠工资属于"告诉才处理"的犯罪，如果在收到钱之前就签署不追究刑责的撤诉书，即使雇主之后违背承诺，也无法再次提出陈情。',
                vi: 'Vì tội nợ lương chỉ bị xử lý khi có yêu cầu của người bị hại, nên nếu ký đơn "không mong muốn xử phạt" trước khi nhận được tiền, thì dù sau đó người sử dụng lao động không giữ lời hứa, bạn cũng không thể khiếu nại lại.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '대화 기록 남기는 법',
              en: 'How to Keep a Record of the Conversation',
              zh: '如何留存沟通记录',
              vi: 'Cách lưu lại hồ sơ trao đổi',
            ),
            bullets: [
              L10nText(
                ko: '전화 통화보다는 문자·카카오톡처럼 기록이 남는 수단을 우선 사용하세요.',
                en: 'Prefer methods that leave a record, such as text messages or KakaoTalk, over phone calls.',
                zh: '请优先使用短信、KakaoTalk等能留下记录的方式，而非电话通话。',
                vi: 'Ưu tiên sử dụng các phương tiện có thể lưu lại bằng chứng như tin nhắn, KakaoTalk thay vì gọi điện thoại.',
              ),
              L10nText(
                ko: '통화를 했다면 통화 직후 내용을 요약해 상대방에게 다시 문자로 보내 기록을 남기는 것도 방법입니다.',
                en: 'If you did have a phone call, it also helps to summarize the content right after and send it back to the other person by text to create a written record.',
                zh: '如果进行了电话通话，通话结束后立即将内容总结并以短信重新发给对方，也是留存记录的一种方法。',
                vi: 'Nếu đã gọi điện, một cách khác là ngay sau cuộc gọi hãy tóm tắt nội dung và gửi lại cho đối phương bằng tin nhắn để lưu làm bằng chứng.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '3단계: 진정 접수',
          en: 'Step 3: Filing the Petition',
          zh: '第三步：提交陈情书',
          vi: 'Bước 3: Nộp đơn khiếu nại',
        ),
        summary: L10nText(
          ko: '관할 지방고용노동청에 체불 사실을 알리고 해결을 공식 요청하는 단계이며, 노동포털 온라인·방문·우편·팩스 모두 가능합니다.',
          en: 'This is the stage where you notify the regional employment and labor office with jurisdiction of the unpaid wages and formally request resolution. You can file online through the Labor Portal, in person, by mail, or by fax.',
          zh: '这一步是向管辖地区雇佣劳动厅告知欠薪事实，并正式请求解决问题的阶段，可通过劳动门户网站在线提交，也可到访办理，或通过邮寄、传真提交。',
          vi: 'Đây là giai đoạn thông báo về việc bị nợ lương cho Sở Việc làm và Lao động khu vực có thẩm quyền và chính thức yêu cầu giải quyết; có thể nộp trực tuyến qua Cổng thông tin Lao động, nộp trực tiếp, gửi qua bưu điện hoặc fax.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '임금체불 진정서, 신분증(외국인등록증)',
                en: 'Unpaid wages petition, ID (Alien Registration Card)',
                zh: '拖欠工资陈情书、身份证件（外国人登录证）',
                vi: 'Đơn khiếu nại nợ lương, giấy tờ tùy thân (Thẻ đăng ký người nước ngoài)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '진정은 처벌보다 지급 지도가 목적입니다. 접수 후 대개 일주일 안에 근로감독관이 배정되고 2주 안팎으로 출석 조사가 잡힙니다.',
                en: 'The purpose of a petition is to guide the employer toward payment, not to seek punishment. A labor inspector is usually assigned within about a week of filing, and an in-person investigation is typically scheduled within around 2 weeks.',
                zh: '陈情的目的是督促支付而非追究处罚。提交后通常一周内会分配劳动监督官，并在两周左右安排出庭调查。',
                vi: 'Mục đích của việc khiếu nại là hướng dẫn thanh toán chứ không phải xử phạt. Sau khi nộp đơn, thông thường trong vòng một tuần sẽ có thanh tra lao động phụ trách và cuộc điều tra trực tiếp sẽ được sắp xếp trong khoảng 2 tuần.',
              ),
              L10nText(
                ko: '처벌을 원한다면 형사 고소라는 별개 절차를 선택해야 합니다.',
                en: 'If you want the employer punished, you must choose the separate procedure of filing a criminal complaint.',
                zh: '如果希望追究刑事处罚，需要另行选择刑事告诉这一独立程序。',
                vi: 'Nếu muốn xử phạt, bạn phải chọn thủ tục riêng là tố cáo hình sự.',
              ),
              L10nText(
                ko: '접수 방법: 고용노동부 민원마당(노동포털) 온라인 접수, 관할 노동청 방문·팩스',
                en: 'How to file: online via the Ministry of Employment and Labor Civil Service Portal (Labor Portal), or in person/by fax at the regional labor office',
                zh: '受理方式：雇佣劳动部民愿广场（劳动门户网站）在线申请，或到管辖劳动厅现场办理／传真',
                vi: 'Cách nộp đơn: nộp trực tuyến qua Cổng dân nguyện của Bộ Việc làm và Lao động (Cổng thông tin Lao động), hoặc nộp trực tiếp/fax tại Sở Lao động có thẩm quyền',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '접수 경로 3가지',
              en: '3 Ways to File',
              zh: '三种受理途径',
              vi: '3 cách nộp đơn',
            ),
            bullets: [
              L10nText(
                ko: '고용노동부 민원마당(노동포털) 온라인 접수',
                en: 'Online filing via the Ministry of Employment and Labor Civil Service Portal (Labor Portal)',
                zh: '雇佣劳动部民愿广场（劳动门户网站）在线申请',
                vi: 'Nộp trực tuyến qua Cổng dân nguyện của Bộ Việc làm và Lao động (Cổng thông tin Lao động)',
              ),
              L10nText(
                ko: '관할 지방고용노동청 방문 접수',
                en: 'In-person filing at the regional employment and labor office with jurisdiction',
                zh: '到管辖地区雇佣劳动厅现场办理',
                vi: 'Nộp trực tiếp tại Sở Việc làm và Lao động khu vực có thẩm quyền',
              ),
              L10nText(
                ko: '우편·팩스 접수',
                en: 'Filing by mail or fax',
                zh: '邮寄或传真提交',
                vi: 'Nộp qua bưu điện hoặc fax',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '4단계: 출석 조사',
          en: 'Step 4: In-Person Investigation',
          zh: '第四步：出庭调查',
          vi: 'Bước 4: Điều tra trực tiếp',
        ),
        summary: L10nText(
          ko: '담당 근로감독관의 호출에 따라 출석해 조사를 받는 단계로, 사업주와 주장이 엇갈리면 삼자대면이 잡힐 수 있습니다.',
          en: 'This is the stage where you appear for an interview at the summons of the labor inspector in charge. If your account differs from the employer\'s, a three-way meeting may be scheduled.',
          zh: '这一步是根据负责的劳动监督官的传唤前往接受调查的阶段，若与雇主陈述不一致，可能会安排三方对质。',
          vi: 'Đây là giai đoạn có mặt theo triệu tập của thanh tra lao động phụ trách để tiến hành điều tra; nếu lời khai khác với người sử dụng lao động, có thể sẽ được sắp xếp buổi đối chất ba bên.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 것',
              en: 'What to Prepare',
              zh: '需要准备的内容',
              vi: 'Những gì cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '신분증, 제출 증거자료 원본, 출석 통지서',
                en: 'ID, original copies of the evidence submitted, appearance notice',
                zh: '身份证件、所提交证据材料原件、出庭通知书',
                vi: 'Giấy tờ tùy thân, bản gốc tài liệu bằng chứng đã nộp, thông báo triệu tập',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '사업주와 함께 있는 것이 불편하면 분리 조사를 요구할 수 있고, 통역원 동석도 미리 신청할 수 있습니다.',
                en: 'If it is uncomfortable being interviewed together with the employer, you can request a separate interview, and you can also apply in advance for an interpreter to be present.',
                zh: '若不便与雇主同时在场，可要求分开调查，也可提前申请安排口译员陪同。',
                vi: 'Nếu cảm thấy bất tiện khi có mặt cùng người sử dụng lao động, bạn có thể yêu cầu điều tra riêng, đồng thời có thể đăng ký trước để có phiên dịch viên đi cùng.',
              ),
              L10nText(
                ko: '첫 조사에서 서류를 다 못 냈어도 이후 이메일·팩스·서면 의견서로 보완할 수 있습니다.',
                en: 'Even if you could not submit all documents at the first interview, you can supplement them afterward by email, fax, or a written statement.',
                zh: '即使首次调查时未能提交全部材料，之后也可以通过邮件、传真或书面意见书进行补充。',
                vi: 'Ngay cả khi chưa nộp đủ hồ sơ trong lần điều tra đầu tiên, bạn vẫn có thể bổ sung sau đó qua email, fax hoặc ý kiến bằng văn bản.',
              ),
              L10nText(
                ko: '감독관이 합의를 권해도 받을 금액을 서둘러 깎을 이유는 없습니다.',
                en: 'Even if the inspector suggests a settlement, there is no need to hastily reduce the amount you are owed.',
                zh: '即使监督官建议和解，也没有必要急于压低应得的金额。',
                vi: 'Ngay cả khi thanh tra khuyên nên hòa giải, bạn cũng không có lý do gì phải vội vàng giảm số tiền đáng lẽ được nhận.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '통역 지원 신청',
              en: 'Requesting Interpretation Support',
              zh: '申请口译支持',
              vi: 'Đăng ký hỗ trợ phiên dịch',
            ),
            bullets: [
              L10nText(
                ko: '조사 전 담당 근로감독관에게 미리 통역 필요 여부를 알리면 통역인이 배정될 수 있습니다.',
                en: 'If you inform the labor inspector in charge before the interview that you need an interpreter, one may be assigned to you.',
                zh: '在调查前提前告知负责的劳动监督官需要口译，可能会为您安排口译人员。',
                vi: 'Nếu thông báo trước cho thanh tra lao động phụ trách rằng bạn cần phiên dịch, có thể sẽ được sắp xếp phiên dịch viên.',
              ),
              L10nText(
                ko: '1345·BBB코리아 통역을 동행하는 방법도 있습니다.',
                en: 'You can also bring an interpreter along through services such as 1345 or BBB Korea.',
                zh: '也可以通过1345、BBB韩国等服务陪同口译人员前往。',
                vi: 'Bạn cũng có thể đưa phiên dịch viên đi cùng thông qua các dịch vụ như 1345, BBB Korea.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '5단계: 체불확인서 발급',
          en: 'Step 5: Issuance of the Unpaid Wages Confirmation',
          zh: '第五步：领取欠薪确认书',
          vi: 'Bước 5: Cấp Giấy xác nhận nợ lương',
        ),
        summary: L10nText(
          ko: '체불 사실이 확정된 뒤 정식 명칭 "체불 임금등·사업주 확인서"를 발급받는 단계로, 다음 단계인 대지급금이나 민사 절차로 넘어가기 위한 필수 서류입니다.',
          en: 'This is the stage where, once the unpaid wages are confirmed, you receive the document formally called the "Confirmation of Unpaid Wages, Etc., and Employer." It is a required document for moving on to the next stage — the Wage Claim Guarantee Payment or civil proceedings.',
          zh: '这一步是在欠薪事实确定后，领取正式名称为"欠薪工资等·雇主确认书"的阶段，这是进入下一步（代垫金或民事程序）所必需的文件。',
          vi: 'Đây là giai đoạn nhận văn bản có tên chính thức là "Giấy xác nhận tiền lương bị nợ và người sử dụng lao động" sau khi sự việc nợ lương được xác định; đây là tài liệu bắt buộc để chuyển sang bước tiếp theo là tiền tạm ứng thay trả lương hoặc thủ tục dân sự.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '체불임금등·사업주확인서 발급 신청서',
                en: 'Application for issuance of the Confirmation of Unpaid Wages, Etc., and Employer',
                zh: '欠薪工资等·雇主确认书发放申请书',
                vi: 'Đơn xin cấp Giấy xác nhận tiền lương bị nợ và người sử dụng lao động',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '이 확인서가 있어야 간이대지급금이나 민사소송으로 넘어갈 수 있습니다.',
                en: 'You need this confirmation document to proceed to the Simplified Wage Claim Guarantee Payment or a civil lawsuit.',
                zh: '只有持有这份确认书，才能进入简易代垫金或民事诉讼程序。',
                vi: 'Phải có giấy xác nhận này thì mới có thể chuyển sang tiền tạm ứng thay trả lương đơn giản hoặc khởi kiện dân sự.',
              ),
              L10nText(
                ko: '발급받으면 원본을 잃어버리지 말고 사본을 별도 보관하세요.',
                en: 'Once issued, do not lose the original — keep a separate copy as well.',
                zh: '领取后请妥善保管原件，切勿遗失，并另行保存复印件。',
                vi: 'Sau khi nhận được, không được làm mất bản gốc và hãy giữ thêm một bản sao riêng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '확인서 발급 이후',
              en: 'After Receiving the Confirmation',
              zh: '领取确认书之后',
              vi: 'Sau khi nhận được giấy xác nhận',
            ),
            bullets: [
              L10nText(
                ko: '발급받은 확인서는 스캔해 별도 보관하고, 다음 단계(간이대지급금 또는 민사)에 맞춰 바로 활용하세요.',
                en: 'Scan the confirmation document and keep a separate copy, then use it right away for the next stage (Simplified Wage Claim Guarantee Payment or civil proceedings).',
                zh: '将领取的确认书扫描后另行保存，并立即用于下一阶段（简易代垫金或民事程序）。',
                vi: 'Hãy quét giấy xác nhận đã nhận và lưu riêng một bản, sau đó sử dụng ngay cho bước tiếp theo (tiền tạm ứng thay trả lương đơn giản hoặc thủ tục dân sự).',
              ),
              L10nText(
                ko: '확인서에 적힌 체불액과 본인이 계산한 금액이 다르면 근로감독관에게 사유를 확인하세요.',
                en: 'If the unpaid amount stated in the confirmation differs from the amount you calculated, check the reason with the labor inspector.',
                zh: '如果确认书上记载的欠薪金额与您自己计算的金额不同，请向劳动监督官核实原因。',
                vi: 'Nếu số tiền nợ lương ghi trong giấy xác nhận khác với số tiền bạn tự tính, hãy xác nhận lý do với thanh tra lao động.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '6단계: 간이대지급금',
          en: 'Step 6: Simplified Wage Claim Guarantee Payment',
          zh: '第六步：简易代垫金',
          vi: 'Bước 6: Tiền tạm ứng thay trả lương đơn giản',
        ),
        summary: L10nText(
          ko: '사업주가 지급하지 못하거나 거부할 때 국가가 먼저 지급하는 제도로, 임금과 퇴직금을 합해 최대 1,000만 원 한도로 알려져 있습니다.',
          en: 'This is a system where the state pays first when the employer is unable to or refuses to pay. It is understood to have a cap of up to KRW 10 million combined for wages and severance pay.',
          zh: '这是在雇主无力支付或拒绝支付时，由国家先行垫付的制度，据了解工资与退职金合计上限为1,000万韩元。',
          vi: 'Đây là chế độ nhà nước tạm ứng trả trước khi người sử dụng lao động không thể hoặc từ chối thanh toán, được biết có giới hạn tối đa 10 triệu won gộp cả tiền lương và trợ cấp thôi việc.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '체불확인서 원본, 지급청구서, 본인 명의 통장 사본',
                en: 'Original unpaid wages confirmation, payment claim form, copy of your own bank passbook',
                zh: '欠薪确认书原件、支付请求书、本人名义银行存折复印件',
                vi: 'Bản gốc giấy xác nhận nợ lương, đơn yêu cầu thanh toán, bản sao sổ tài khoản đứng tên mình',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '법원 판결 없이 노동청 확인서만으로 청구할 수 있고, 접수 후 대략 두 달 안에 지급되는 것으로 알려져 있습니다.',
                en: 'You can file a claim using only the labor office\'s confirmation, without a court ruling, and payment is understood to be made within about two months of filing.',
                zh: '无需法院判决，仅凭劳动厅确认书即可申请，据了解受理后大约两个月内即可获得支付。',
                vi: 'Có thể yêu cầu chỉ bằng giấy xác nhận của Sở Lao động mà không cần phán quyết của tòa án, và được biết sẽ được thanh toán trong khoảng hai tháng sau khi nộp đơn.',
              ),
              L10nText(
                ko: '청구 기한이 정해져 있으므로 확인서를 받으면 미루지 말고 바로 진행하세요.',
                en: 'Since there is a filing deadline, proceed right away once you receive the confirmation — do not delay.',
                zh: '申请有截止期限，领到确认书后请勿拖延，立即办理。',
                vi: 'Vì có thời hạn yêu cầu nhất định, nên khi nhận được giấy xác nhận, hãy tiến hành ngay chứ không nên trì hoãn.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '대지급금 종류',
              en: 'Types of Wage Claim Guarantee Payment',
              zh: '代垫金的种类',
              vi: 'Các loại tiền tạm ứng thay trả lương',
            ),
            bullets: [
              L10nText(
                ko: '도산 등 사실인정이 필요한 \'일반대지급금\'과 법원 확정판결 없이 노동청 확인만으로 진행되는 \'간이대지급금\'으로 나뉩니다.',
                en: 'It is divided into the "General Wage Claim Guarantee Payment," which requires official recognition of a fact such as bankruptcy, and the "Simplified Wage Claim Guarantee Payment," which proceeds with only a labor office confirmation and no final court judgment.',
                zh: '分为需要认定破产等事实的"一般代垫金"，以及无需法院终审判决、仅凭劳动厅确认即可办理的"简易代垫金"。',
                vi: 'Chia thành "tiền tạm ứng thay trả lương thông thường" cần xác nhận sự việc như phá sản, và "tiền tạm ứng thay trả lương đơn giản" chỉ cần xác nhận của Sở Lao động mà không cần phán quyết cuối cùng của tòa án.',
              ),
              L10nText(
                ko: '일반적으로 재직 중 체불에는 간이대지급금이 더 빠르게 활용됩니다.',
                en: 'For unpaid wages that occurred while still employed, the Simplified Wage Claim Guarantee Payment is generally used because it is faster.',
                zh: '一般而言，在职期间发生的欠薪更适合使用速度更快的简易代垫金。',
                vi: 'Nói chung, đối với nợ lương phát sinh trong thời gian còn đang làm việc, tiền tạm ứng thay trả lương đơn giản được sử dụng nhanh hơn.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '7단계: 민사·지급명령',
          en: 'Step 7: Civil Litigation and Payment Order',
          zh: '第七步：民事诉讼·支付令',
          vi: 'Bước 7: Dân sự và lệnh thanh toán',
        ),
        summary: L10nText(
          ko: '체불액이 대지급금 한도를 넘거나 사업주가 계속 버틸 때 집행권원을 확보하는 단계이며, 지급명령은 법정에 나가지 않고 서류만으로 진행됩니다.',
          en: 'This is the stage for securing a title of execution when the unpaid amount exceeds the Wage Claim Guarantee Payment cap or the employer keeps refusing to pay. A payment order proceeds using documents only, without appearing in court.',
          zh: '这一步是在欠薪金额超过代垫金上限或雇主持续拖延时，取得执行名义的阶段；支付令无需出庭，仅凭书面材料即可办理。',
          vi: 'Đây là giai đoạn xác lập danh nghĩa thi hành án khi số tiền nợ lương vượt quá giới hạn tiền tạm ứng thay trả lương hoặc người sử dụng lao động tiếp tục trì hoãn; lệnh thanh toán được tiến hành chỉ bằng hồ sơ giấy tờ mà không cần ra tòa.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '체불확인서, 민사소장 또는 지급명령 신청서',
                en: 'Unpaid wages confirmation, civil complaint or payment order application',
                zh: '欠薪确认书、民事起诉状或支付令申请书',
                vi: 'Giấy xác nhận nợ lương, đơn khởi kiện dân sự hoặc đơn xin lệnh thanh toán',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '월 평균임금이 일정 기준 미만이면 대한법률구조공단(132)의 무료 법률구조를 받을 수 있습니다. 소득 요건(기준 중위소득 125% 이하)을 먼저 확인하세요.',
                en: 'If your average monthly wage is below a certain threshold, you can receive free legal aid from the Korea Legal Aid Corporation (132). Check the income requirement first (125% or less of the standard median income).',
                zh: '如果月平均工资低于一定标准，可获得大韩法律救助公团（132）的免费法律援助。请先确认收入条件（基准中位收入的125%以下）。',
                vi: 'Nếu mức lương trung bình hằng tháng thấp hơn một tiêu chuẩn nhất định, bạn có thể được Tổng công ty Hỗ trợ pháp lý Hàn Quốc (132) hỗ trợ pháp lý miễn phí. Hãy kiểm tra điều kiện thu nhập trước (dưới 125% thu nhập trung vị chuẩn).',
              ),
              L10nText(
                ko: '체불액이 3,000만 원 이하면 소액사건심판으로 더 간단하게 진행할 수 있습니다.',
                en: 'If the unpaid amount is KRW 30 million or less, you can proceed more simply through a small claims trial.',
                zh: '如果欠薪金额在3,000万韩元以下，可通过小额诉讼程序更简便地处理。',
                vi: 'Nếu số tiền nợ lương từ 30 triệu won trở xuống, có thể tiến hành đơn giản hơn qua thủ tục xét xử vụ án nhỏ.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '지급명령 이의신청 시',
              en: 'If the Employer Objects to the Payment Order',
              zh: '雇主对支付令提出异议时',
              vi: 'Khi có khiếu nại đối với lệnh thanh toán',
            ),
            bullets: [
              L10nText(
                ko: '사업주가 지급명령에 이의신청을 하면 정식 민사소송으로 자동 전환됩니다.',
                en: 'If the employer objects to the payment order, the case automatically converts into a formal civil lawsuit.',
                zh: '如果雇主对支付令提出异议，案件将自动转为正式的民事诉讼。',
                vi: 'Nếu người sử dụng lao động khiếu nại đối với lệnh thanh toán, vụ việc sẽ tự động chuyển thành vụ kiện dân sự chính thức.',
              ),
              L10nText(
                ko: '이 경우를 대비해 처음부터 증거자료를 소송용으로 정리해두는 것이 좋습니다.',
                en: 'To prepare for this possibility, it is a good idea to organize your evidence for litigation from the very beginning.',
                zh: '为应对这种情况，建议从一开始就将证据材料按诉讼要求整理好。',
                vi: 'Để phòng trường hợp này, bạn nên chuẩn bị và sắp xếp tài liệu bằng chứng cho việc kiện tụng ngay từ đầu.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '8단계: 집행과 이직',
          en: 'Step 8: Enforcement and Changing Workplaces',
          zh: '第八步：强制执行与换工作',
          vi: 'Bước 8: Cưỡng chế thi hành và chuyển việc',
        ),
        summary: L10nText(
          ko: '사업주 재산에 대한 압류·경매를 진행하고, 체불로 인한 사업장 변경을 처리하는 마지막 단계입니다.',
          en: 'This is the final stage — seizing and auctioning the employer\'s assets, and handling a change of workplace due to the unpaid wages.',
          zh: '这是最后一步，对雇主的财产进行查封、拍卖，并处理因欠薪导致的换工作事宜。',
          vi: 'Đây là giai đoạn cuối cùng — tiến hành kê biên, đấu giá tài sản của người sử dụng lao động, và xử lý việc chuyển nơi làm việc do bị nợ lương.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '확정 판결문·지급명령 결정문, 사업장 변경 신청서',
                en: 'Final judgment/payment order decision, application to change workplace',
                zh: '生效判决书、支付令裁定书、更换工作单位申请书',
                vi: 'Bản án/quyết định lệnh thanh toán đã có hiệu lực, đơn xin chuyển nơi làm việc',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '판결을 받아도 사업주에게 압류할 재산이 없으면 실제 회수가 어렵습니다. 노동청 단계부터 사업자 계좌·차량·거래처 등 재산 상태를 함께 파악해두고, 재산을 빼돌리는 정황이 보이면 가압류를 먼저 검토하세요.',
                en: 'Even with a judgment in hand, actual recovery is difficult if the employer has no seizable assets. From the labor office stage onward, try to identify the employer\'s asset status — business accounts, vehicles, business partners — and if you notice signs of assets being hidden or moved, consider a provisional attachment first.',
                zh: '即使胜诉，如果雇主没有可供查封的财产，实际追偿也很困难。建议从劳动厅阶段起就一并掌握雇主的账户、车辆、往来客户等财产状况，若发现有转移财产的迹象，应优先考虑申请诉前财产保全。',
                vi: 'Dù có được phán quyết, nếu người sử dụng lao động không có tài sản để kê biên thì việc thu hồi thực tế sẽ khó khăn. Ngay từ giai đoạn ở Sở Lao động, hãy nắm bắt tình trạng tài sản như tài khoản kinh doanh, xe cộ, đối tác giao dịch; nếu thấy dấu hiệu tẩu tán tài sản, hãy cân nhắc biện pháp phong tỏa tài sản tạm thời trước.',
              ),
              L10nText(
                ko: '체불이 증명되면 이 사업장 변경은 사업장 변경 횟수 제한에서 차감되지 않습니다 — ④체류신고 참고',
                en: 'If the unpaid wages are proven, this change of workplace does not count against the limit on the number of workplace changes — see ④Report of Sojourn.',
                zh: '如果欠薪事实得到证明，此次更换工作单位不计入更换工作单位次数限制——请参考④居留申报',
                vi: 'Nếu chứng minh được việc bị nợ lương, lần chuyển nơi làm việc này sẽ không bị tính vào giới hạn số lần chuyển nơi làm việc — tham khảo mục ④Khai báo cư trú',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '이직 후에도 청구권 유지',
              en: 'Your Claim Remains Valid Even After Changing Jobs',
              zh: '换工作后请求权依然有效',
              vi: 'Quyền yêu cầu vẫn được duy trì sau khi chuyển việc',
            ),
            bullets: [
              L10nText(
                ko: '사업장을 변경하거나 퇴사해도 체불임금 청구권 자체는 소멸시효 내에서 그대로 유지됩니다.',
                en: 'Even if you change workplaces or leave your job, your right to claim unpaid wages remains valid within the statute of limitations.',
                zh: '即使更换工作单位或离职，只要在消灭时效内，追讨欠薪的请求权本身依然有效。',
                vi: 'Ngay cả khi chuyển nơi làm việc hoặc nghỉ việc, quyền yêu cầu tiền lương bị nợ vẫn được duy trì trong thời hiệu.',
              ),
              L10nText(
                ko: '새 직장을 구했더라도 이전 사업장의 체불 절차는 별개로 계속 진행할 수 있습니다.',
                en: 'Even after finding a new job, you can continue the unpaid wages procedure against your former workplace separately.',
                zh: '即使已找到新工作，针对前一家工作单位的欠薪处理程序仍可单独继续进行。',
                vi: 'Ngay cả khi đã tìm được công việc mới, thủ tục xử lý nợ lương ở nơi làm việc trước đó vẫn có thể tiếp tục tiến hành độc lập.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '임금체불 진정서 서식 미리보기',
          en: 'Preview: Unpaid Wages Petition Form',
          zh: '预览：拖欠工资陈情书表格',
          vi: 'Xem trước: Mẫu đơn khiếu nại nợ lương',
        ),
        summary: L10nText(
          ko: '고용노동부 노동포털 접수 서식입니다. 자동입력·직접입력·원문그대로 구간을 색으로 구분했습니다.',
          en: 'This is the filing form used on the Ministry of Employment and Labor\'s Labor Portal. Auto-filled, user-entered, and fixed-text sections are color-coded.',
          zh: '这是雇佣劳动部劳动门户网站的受理表格。自动填写、手动填写和原文照录的部分以颜色区分。',
          vi: 'Đây là mẫu nộp đơn trên Cổng thông tin Lao động của Bộ Việc làm và Lao động. Các phần tự động điền, tự nhập và giữ nguyên văn bản gốc được phân biệt bằng màu sắc.',
        ),
        form: FormPreview(
          title: L10nText(
            ko: '임금체불 진정서',
            en: 'Unpaid Wages Petition',
            zh: '拖欠工资陈情书',
            vi: 'Đơn khiếu nại nợ lương',
          ),
          subtitle: L10nText(
            ko: '(　)고용노동(지)청장 귀하 · 노동포털 접수 서식',
            en: 'To the Head of the (　) Employment and Labor Office · Labor Portal filing form',
            zh: '致(　)雇佣劳动(支)厅长 · 劳动门户网站受理表格',
            vi: 'Kính gửi Trưởng Sở Việc làm và Lao động (　) · Mẫu nộp đơn trên Cổng thông tin Lao động',
          ),
          rows: [
            FormRowData.section(
              section: L10nText(
                ko: '1. 진정인',
                en: '1. Petitioner',
                zh: '1. 陈情人',
                vi: '1. Người khiếu nại',
              ),
              sub: L10nText(
                ko: '근로자 본인',
                en: 'The worker (yourself)',
                zh: '劳动者本人',
                vi: 'Bản thân người lao động',
              ),
            ),
            FormRowData.field(
              label: L10nText(ko: '성명', en: 'Name', zh: '姓名', vi: 'Họ và tên'),
              value: L10nText(
                ko: '응우옌 반 남 (NGUYEN VAN NAM)',
                en: 'NGUYEN VAN NAM',
                zh: 'NGUYEN VAN NAM（阮文南）',
                vi: 'NGUYEN VAN NAM',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '외국인등록번호',
                en: 'Alien Registration Number',
                zh: '外国人登录号',
                vi: 'Số đăng ký người nước ngoài',
              ),
              value: L10nText(
                ko: '프로필에서 자동 입력',
                en: 'Auto-filled from your profile',
                zh: '从个人资料中自动填写',
                vi: 'Tự động điền từ hồ sơ cá nhân',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '주소 · 휴대전화',
                en: 'Address · Mobile Phone',
                zh: '地址·手机号码',
                vi: 'Địa chỉ · Số điện thoại di động',
              ),
              value: L10nText(
                ko: '프로필 체류지 주소와 연락처',
                en: 'Your registered address of stay and contact number from your profile',
                zh: '个人资料中的居留地址和联系方式',
                vi: 'Địa chỉ cư trú và số liên lạc trong hồ sơ cá nhân',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(ko: '전자우편', en: 'Email', zh: '电子邮件', vi: 'Email'),
              value: L10nText(
                ko: '처리 상황 통지를 받을 주소',
                en: 'The address where you will receive status notifications',
                zh: '用于接收处理进度通知的邮箱地址',
                vi: 'Địa chỉ nhận thông báo tình trạng xử lý',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '노동포털 통지 여부',
                en: 'Labor Portal Notifications',
                zh: '是否通过劳动门户网站接收通知',
                vi: 'Có nhận thông báo qua Cổng thông tin Lao động hay không',
              ),
              value: L10nText(
                ko: '[예]로 두는 것을 권장',
                en: 'Recommended to leave this set to [Yes]',
                zh: '建议保留为[是]',
                vi: 'Khuyến nghị để ở mức [Có]',
              ),
              tag: 'auto',
            ),
            FormRowData.section(
              section: L10nText(
                ko: '2. 피진정인',
                en: '2. Respondent',
                zh: '2. 被陈情人',
                vi: '2. Người bị khiếu nại',
              ),
              sub: L10nText(
                ko: '사업주',
                en: 'The employer',
                zh: '雇主',
                vi: 'Người sử dụng lao động',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '성명 · 연락처',
                en: 'Name · Contact Number',
                zh: '姓名·联系方式',
                vi: 'Họ tên · Số liên lạc',
              ),
              value: L10nText(
                ko: '근무지 등록 정보에서 가져옴',
                en: 'Pulled from your registered workplace information',
                zh: '从工作单位登记信息中获取',
                vi: 'Lấy từ thông tin nơi làm việc đã đăng ký',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '사업체 구분',
                en: 'Business Type',
                zh: '企业类型',
                vi: 'Loại hình cơ sở kinh doanh',
              ),
              value: L10nText(
                ko: '사업장 또는 공사현장 중 선택',
                en: 'Choose either "workplace" or "construction site"',
                zh: '在"事业场"或"施工现场"中选择',
                vi: 'Chọn "nơi làm việc" hoặc "công trường xây dựng"',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '사업장명 · 주소',
                en: 'Workplace Name · Address',
                zh: '单位名称·地址',
                vi: 'Tên nơi làm việc · Địa chỉ',
              ),
              value: L10nText(
                ko: '실제 근무한 장소를 적어야 관할이 정해짐',
                en: 'You must enter the actual place you worked, since this determines jurisdiction',
                zh: '必须填写实际工作地点，这将决定管辖机构',
                vi: 'Phải ghi địa điểm làm việc thực tế vì đây là căn cứ xác định thẩm quyền quản lý',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '근로자 수',
                en: 'Number of Employees',
                zh: '员工人数',
                vi: 'Số lượng người lao động',
              ),
              value: L10nText(
                ko: '임금계산 시 고른 5인 기준과 일치해야 함',
                en: 'Must match the 5-employee threshold you selected when calculating wages',
                zh: '须与计算工资时选择的5人标准一致',
                vi: 'Phải khớp với tiêu chuẩn 5 lao động đã chọn khi tính lương',
              ),
              tag: 'auto',
            ),
            FormRowData.section(
              section: L10nText(
                ko: '3. 진정 내용',
                en: '3. Details of the Petition',
                zh: '3. 陈情内容',
                vi: '3. Nội dung khiếu nại',
              ),
              sub: L10nText(
                ko: '체불 내역',
                en: 'Unpaid wage details',
                zh: '欠薪明细',
                vi: 'Chi tiết nợ lương',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '입사일 · 퇴사일',
                en: 'Date of Hire · Date of Leaving',
                zh: '入职日期·离职日期',
                vi: 'Ngày vào làm · Ngày nghỉ việc',
              ),
              value: L10nText(
                ko: '근무기록에서 가져옴',
                en: 'Pulled from your work records',
                zh: '从工作记录中获取',
                vi: 'Lấy từ hồ sơ làm việc',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '퇴직 여부',
                en: 'Employment Status',
                zh: '离职与否',
                vi: 'Tình trạng nghỉ việc',
              ),
              value: L10nText(
                ko: '퇴직 또는 재직 중 선택',
                en: 'Choose either "left the job" or "still employed"',
                zh: '在"已离职"或"在职"中选择',
                vi: 'Chọn "đã nghỉ việc" hoặc "đang làm việc"',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '업무 내용 · 임금 지급일',
                en: 'Job Duties · Payday',
                zh: '工作内容·发薪日',
                vi: 'Nội dung công việc · Ngày trả lương',
              ),
              value: L10nText(
                ko: '계약서 내용 그대로',
                en: 'Exactly as stated in the contract',
                zh: '与合同内容一致',
                vi: 'Giống nguyên văn trong hợp đồng',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '근로계약 방법',
                en: 'Form of Employment Contract',
                zh: '劳动合同形式',
                vi: 'Hình thức hợp đồng lao động',
              ),
              value: L10nText(
                ko: '서면 또는 구두 중 선택',
                en: 'Choose either "written" or "verbal"',
                zh: '在"书面"或"口头"中选择',
                vi: 'Chọn "bằng văn bản" hoặc "bằng lời nói"',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '체불임금 총액',
                en: 'Total Unpaid Wages',
                zh: '拖欠工资总额',
                vi: 'Tổng số tiền lương bị nợ',
              ),
              value: L10nText(
                ko: '직접 입력 — 확정 금액은 근로감독관 조사에서 산정',
                en: 'Enter manually — the final amount will be calculated during the labor inspector\'s investigation',
                zh: '手动填写——最终确定金额将在劳动监督官调查时核算',
                vi: 'Tự nhập — số tiền chính thức sẽ được tính toán trong quá trình điều tra của thanh tra lao động',
              ),
              tag: 'blank',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '체불 퇴직금 · 기타',
                en: 'Unpaid Severance Pay · Other',
                zh: '拖欠退职金·其他',
                vi: 'Trợ cấp thôi việc bị nợ · Khác',
              ),
              value: L10nText(
                ko: '직접 입력',
                en: 'Enter manually',
                zh: '手动填写',
                vi: 'Tự nhập',
              ),
              tag: 'blank',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '내용(진정 취지 및 이유)',
                en: 'Details (Purpose and Grounds of the Petition)',
                zh: '内容（陈情目的及理由）',
                vi: 'Nội dung (Mục đích và lý do khiếu nại)',
              ),
              value: L10nText(
                ko: '1단계에서 정리한 경위를 그대로 기재',
                en: 'Enter the account you organized in Step 1, exactly as written',
                zh: '按第一步整理的经过原样填写',
                vi: 'Ghi lại nguyên văn diễn biến đã tổng hợp ở Bước 1',
              ),
              tag: 'raw',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '파일 첨부',
                en: 'File Attachment',
                zh: '文件附件',
                vi: 'Đính kèm tệp',
              ),
              value: L10nText(
                ko: '계약서·명세서·통장내역 등 증거자료 첨부',
                en: 'Attach evidence such as the contract, pay stub, and bank statement',
                zh: '附上合同、明细单、银行流水等证据材料',
                vi: 'Đính kèm bằng chứng như hợp đồng, bảng lương, sao kê tài khoản',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '위반 법조항',
                en: 'Violated Provision of Law',
                zh: '违反的法律条款',
                vi: 'Điều khoản luật bị vi phạm',
              ),
              value: L10nText(
                ko: '근로감독관이 판단',
                en: 'Determined by the labor inspector',
                zh: '由劳动监督官判定',
                vi: 'Do thanh tra lao động xác định',
              ),
              tag: 'blank',
            ),
          ],
        ),
      ),
    ],
  ),
  11: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '1단계: 초진소견서',
          en: 'Step 1: Initial Medical Opinion',
          zh: '第一步：初诊意见书',
          vi: 'Bước 1: Giấy khám ban đầu',
        ),
        summary: L10nText(
          ko: '다친 즉시 치료를 받고 초진소견서를 발급받는 단계이며, 4일 이상 치료가 필요한 경우 산재로 신청할 수 있습니다.',
          en: 'This is the stage where you get treatment right after the injury and obtain an initial medical opinion. If treatment of 4 days or more is required, you can apply for it as an industrial accident.',
          zh: '这一步是受伤后立即接受治疗并领取初诊意见书的阶段，如果需要治疗4天以上，可以申请工伤认定。',
          vi: 'Đây là giai đoạn ngay sau khi bị thương phải đi khám điều trị và xin cấp giấy khám ban đầu; nếu cần điều trị từ 4 ngày trở lên, có thể xin công nhận tai nạn lao động.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '초진소견서(별지 제3호), 진단서, 의무기록지, 영상 판독지, 응급기록지',
                en: 'Initial medical opinion (Attachment Form No. 3), medical certificate, medical record, imaging report, emergency treatment record',
                zh: '初诊意见书（附件第3号）、诊断书、病历记录、影像判读报告、急诊记录',
                vi: 'Giấy khám ban đầu (Mẫu đính kèm số 3), giấy chứng nhận y tế, hồ sơ bệnh án, phiếu đọc kết quả chẩn đoán hình ảnh, hồ sơ cấp cứu',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '신청 기한은 재해일로부터 3년, 장해·사망은 5년입니다.',
                en: 'The application deadline is 3 years from the date of the accident, or 5 years in cases of disability or death.',
                zh: '申请期限自灾害发生之日起3年，涉及伤残或死亡的为5年。',
                vi: 'Thời hạn xin công nhận là 3 năm kể từ ngày xảy ra tai nạn, đối với trường hợp tàn tật hoặc tử vong là 5 năm.',
              ),
              L10nText(
                ko: '퇴사했더라도 재해 당시 산재보험이 적용되는 사업장의 근로자였다면 3년 안에 신청할 수 있습니다.',
                en: 'Even if you have left the job, you can apply within 3 years as long as you were an employee at a workplace covered by industrial accident insurance at the time of the accident.',
                zh: '即使已经离职，只要在受伤当时是适用工伤保险的事业场的劳动者，就可以在3年内提出申请。',
                vi: 'Ngay cả khi đã nghỉ việc, nếu tại thời điểm xảy ra tai nạn bạn là người lao động của nơi làm việc được áp dụng bảo hiểm tai nạn lao động, bạn vẫn có thể nộp đơn trong vòng 3 năm.',
              ),
              L10nText(
                ko: '주치의가 소견서 작성을 거부해도 상병명과 치료기간이 적힌 진단서로 대체 제출할 수 있습니다.',
                en: 'Even if your attending physician refuses to write an opinion, you can submit a medical certificate stating the diagnosis and treatment period instead.',
                zh: '即使主治医生拒绝出具意见书，也可以用载明病名和治疗期间的诊断书代替提交。',
                vi: 'Ngay cả khi bác sĩ điều trị từ chối viết giấy khám, bạn vẫn có thể nộp thay bằng giấy chứng nhận y tế ghi rõ tên bệnh và thời gian điều trị.',
              ),
              L10nText(
                ko: '병원 원무과에 "일하다 다쳤다"고 명확히 말해야 산재 치료로 기록되고 초진소견서에 업무 관련성이 남습니다.',
                en: 'You must clearly tell the hospital\'s administrative office that "I was injured while working," so that it is recorded as industrial accident treatment and the work-relatedness is noted in the initial medical opinion.',
                zh: '必须明确告知医院医务科"是在工作中受伤的"，这样才能被记录为工伤治疗，并在初诊意见书中体现与工作的关联性。',
                vi: 'Phải nói rõ với phòng hành chính bệnh viện rằng "bị thương trong khi làm việc" thì mới được ghi nhận là điều trị tai nạn lao động và thể hiện mối liên hệ với công việc trong giấy khám ban đầu.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '산재보험 적용 사업장',
              en: 'Workplaces Covered by Industrial Accident Insurance',
              zh: '适用工伤保险的事业场',
              vi: 'Nơi làm việc được áp dụng bảo hiểm tai nạn lao động',
            ),
            bullets: [
              L10nText(
                ko: '근로자를 1인 이상 사용하는 사업장은 원칙적으로 모두 산재보험 적용 대상입니다.',
                en: 'In principle, any workplace employing one or more workers is subject to industrial accident insurance.',
                zh: '原则上，凡雇用1名以上劳动者的事业场均适用工伤保险。',
                vi: 'Về nguyên tắc, mọi nơi làm việc sử dụng từ 1 lao động trở lên đều thuộc đối tượng áp dụng bảo hiểm tai nạn lao động.',
              ),
              L10nText(
                ko: '사업주가 보험료를 내지 않았거나 미가입 상태여도 근로자의 보상 청구 권리에는 영향이 없습니다.',
                en: 'Even if the employer failed to pay premiums or did not enroll, this has no effect on the employee\'s right to claim compensation.',
                zh: '即使雇主未缴纳保险费或未参保，也不影响劳动者的赔偿请求权。',
                vi: 'Ngay cả khi người sử dụng lao động chưa đóng phí bảo hiểm hoặc chưa tham gia, điều này cũng không ảnh hưởng đến quyền yêu cầu bồi thường của người lao động.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '2단계: 증거 수집',
          en: 'Step 2: Gathering Evidence',
          zh: '第二步：收集证据',
          vi: 'Bước 2: Thu thập bằng chứng',
        ),
        summary: L10nText(
          ko: '업무 중 발생했음을 증명할 자료와 목격자를 확보하는 단계로, 업무와 재해 사이의 인과관계를 입증하는 것이 승인의 핵심입니다.',
          en: 'This is the stage where you secure materials and witnesses to prove the accident happened while working. Proving the causal link between the work and the accident is the key to approval.',
          zh: '这一步是收集能够证明伤害发生在工作过程中的资料和目击者的阶段，证明工作与灾害之间的因果关系是获得认定的关键。',
          vi: 'Đây là giai đoạn thu thập tài liệu và nhân chứng để chứng minh tai nạn xảy ra trong khi làm việc; chứng minh được mối quan hệ nhân quả giữa công việc và tai nạn là điều mấu chốt để được công nhận.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '현장 사진, CCTV, 목격자 진술서, 근무기록의 GPS 기록, 작업지시서, 구급활동일지',
                en: 'Photos of the scene, CCTV footage, witness statements, GPS records from work logs, work order, emergency response log',
                zh: '现场照片、监控录像、目击者陈述书、工作记录中的GPS记录、工作指示单、急救活动日志',
                vi: 'Ảnh hiện trường, camera an ninh, bản tường trình của nhân chứng, dữ liệu GPS trong hồ sơ làm việc, phiếu chỉ thị công việc, nhật ký hoạt động cấp cứu',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '현금 합의(공상처리) 제안에 응하지 말고 정식으로 신청하세요. 현금으로 합의하면 나중에 후유증이 생겨도 치료비를 받을 수 없습니다.',
                en: 'Do not accept a cash settlement offer (having it treated as an off-the-books injury) — file a formal claim instead. If you settle in cash, you will not be able to receive treatment costs even if aftereffects appear later.',
                zh: '请勿接受现金和解（私下按"工伤"私了）的提议，应正式提出申请。若接受现金和解，日后即使出现后遗症也无法获得治疗费。',
                vi: 'Đừng chấp nhận đề nghị thỏa thuận bằng tiền mặt (xử lý ngầm không qua thủ tục chính thức) mà hãy nộp đơn chính thức. Nếu thỏa thuận bằng tiền mặt, sau này dù có di chứng cũng không thể nhận được tiền điều trị.',
              ),
              L10nText(
                ko: 'CCTV는 보존 기간이 짧으므로 사고 직후 사업장에 보존을 요청해야 합니다.',
                en: 'Since CCTV footage is only retained for a short time, you must ask the workplace to preserve it right after the accident.',
                zh: '监控录像的保存期限较短，需在事故发生后立即要求单位予以保存。',
                vi: 'Vì thời gian lưu trữ camera an ninh khá ngắn, cần yêu cầu nơi làm việc lưu giữ ngay sau khi xảy ra tai nạn.',
              ),
              L10nText(
                ko: '산재 신청은 사업주의 허락을 받는 일이 아니라 근로자의 권리이며, 사업주에게 거부권이 없습니다.',
                en: 'Filing an industrial accident claim is not something that requires the employer\'s permission — it is the employee\'s right, and the employer has no power to refuse it.',
                zh: '申请工伤认定不需要征得雇主同意，这是劳动者的权利，雇主无权拒绝。',
                vi: 'Việc xin công nhận tai nạn lao động không phải là việc cần sự cho phép của người sử dụng lao động mà là quyền của người lao động, người sử dụng lao động không có quyền từ chối.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '목격자 진술 확보 요령',
              en: 'Tips for Securing Witness Statements',
              zh: '获取目击者陈述的技巧',
              vi: 'Mẹo thu thập lời khai nhân chứng',
            ),
            bullets: [
              L10nText(
                ko: '목격자의 이름·연락처·소속을 사고 직후 확보해두면 나중에 연락이 끊기는 것을 막을 수 있습니다.',
                en: 'Securing the witness\'s name, contact information, and affiliation right after the accident can prevent losing touch with them later.',
                zh: '在事故发生后立即获取目击者的姓名、联系方式和所属单位，可避免日后失去联系。',
                vi: 'Ghi lại tên, thông tin liên lạc và nơi làm việc của nhân chứng ngay sau khi xảy ra tai nạn có thể tránh việc mất liên lạc về sau.',
              ),
              L10nText(
                ko: '가능하면 목격자에게 간단한 진술을 문자로 받아 남겨두는 것도 좋은 방법입니다.',
                en: 'If possible, it is also a good idea to get a brief statement from the witness by text message and keep it on record.',
                zh: '如果可能，请目击者以短信形式提供简短陈述并留存，也是一个好方法。',
                vi: 'Nếu có thể, việc xin nhân chứng gửi lời khai ngắn gọn qua tin nhắn và lưu lại cũng là một cách tốt.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '3단계: 요양급여 신청',
          en: 'Step 3: Applying for Medical Care Benefits',
          zh: '第三步：申请疗养给付',
          vi: 'Bước 3: Xin trợ cấp điều dưỡng',
        ),
        summary: L10nText(
          ko: '근로복지공단에 치료비와 휴업수당 지급을 요청하는 단계이며, 처리기간은 서식상 7일로 적혀 있으나 조사 상황에 따라 늘어날 수 있습니다.',
          en: 'This is the stage where you request payment of treatment costs and temporary disability compensation from the Korea Workers\' Compensation and Welfare Service. The form states a 7-day processing period, but this may be extended depending on the investigation.',
          zh: '这一步是向勤劳福祉公团申请支付治疗费和停工津贴的阶段，表格上标明的处理期限为7天，但可能根据调查情况而延长。',
          vi: 'Đây là giai đoạn yêu cầu Cơ quan Phúc lợi và Bồi thường Lao động Hàn Quốc (COMWEL) chi trả tiền điều trị và trợ cấp nghỉ việc; thời gian xử lý ghi trên mẫu đơn là 7 ngày nhưng có thể kéo dài tùy tình hình điều tra.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '요양급여신청서(별지 제2호), 요양급여신청 소견서(별지 제3호), 출퇴근재해 발생신고서(해당하는 경우)',
                en: 'Application for Medical Care Benefits (Attachment Form No. 2), medical opinion for the application (Attachment Form No. 3), report of commuting accident (if applicable)',
                zh: '疗养给付申请书（附件第2号）、疗养给付申请意见书（附件第3号）、上下班灾害发生申报书（如适用）',
                vi: 'Đơn xin trợ cấp điều dưỡng (Mẫu đính kèm số 2), giấy khám xin trợ cấp điều dưỡng (Mẫu đính kèm số 3), đơn báo cáo tai nạn khi đi lại (nếu có)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '사업주에게 거부권이 없으므로 근로자 혼자 신청할 수 있고, 사업주 도장도 필요 없습니다.',
                en: 'The employer has no power to refuse, so you can apply on your own — the employer\'s seal/stamp is not required.',
                zh: '雇主无权拒绝，劳动者可独自申请，也无需雇主盖章。',
                vi: 'Người sử dụng lao động không có quyền từ chối, nên người lao động có thể tự nộp đơn một mình và không cần con dấu của người sử dụng lao động.',
              ),
              L10nText(
                ko: '사업장관리번호는 근로복지공단 홈페이지 민원조회에서 사업장명으로 검색해 채우면 됩니다.',
                en: 'You can find the workplace management number by searching the workplace name in the civil service lookup on the Korea Workers\' Compensation and Welfare Service website.',
                zh: '事业场管理编号可在勤劳福祉公团官网的民愿查询中，用单位名称搜索后填写。',
                vi: 'Mã số quản lý nơi làm việc có thể tra bằng cách tìm tên nơi làm việc trong mục tra cứu dân nguyện trên trang web của COMWEL rồi điền vào.',
              ),
              L10nText(
                ko: '일부 항목을 잘못 적어도 담당자가 전화로 보완을 안내합니다.',
                en: 'Even if some fields are filled in incorrectly, the case officer will guide you by phone on how to correct them.',
                zh: '即使部分内容填写有误，负责人也会通过电话指导补正。',
                vi: 'Ngay cả khi điền sai một số mục, cán bộ phụ trách sẽ hướng dẫn bổ sung qua điện thoại.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '출퇴근재해도 포함',
              en: 'Commuting Accidents Are Also Covered',
              zh: '上下班灾害也包含在内',
              vi: 'Tai nạn khi đi làm/tan làm cũng được bao gồm',
            ),
            bullets: [
              L10nText(
                ko: '통상적인 경로와 방법으로 출퇴근하던 중 발생한 사고도 산재로 인정될 수 있습니다.',
                en: 'An accident that occurs while commuting by a customary route and method can also be recognized as an industrial accident.',
                zh: '按通常路线和方式上下班途中发生的事故也可能被认定为工伤。',
                vi: 'Tai nạn xảy ra trong khi đi làm/tan làm theo tuyến đường và phương thức thông thường cũng có thể được công nhận là tai nạn lao động.',
              ),
              L10nText(
                ko: '경로를 벗어난 사적인 용무 중 사고는 인정되지 않을 수 있으니 경위를 정확히 기록하세요.',
                en: 'An accident that occurs while off-route on personal business may not be recognized, so record the circumstances accurately.',
                zh: '偏离路线办理私事期间发生的事故可能不被认定，请准确记录事发经过。',
                vi: 'Tai nạn xảy ra khi đi lệch tuyến đường để giải quyết việc riêng có thể không được công nhận, vì vậy hãy ghi chép chính xác diễn biến sự việc.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '4단계: 현장 조사',
          en: 'Step 4: On-Site Investigation',
          zh: '第四步：现场调查',
          vi: 'Bước 4: Điều tra hiện trường',
        ),
        summary: L10nText(
          ko: '근로복지공단이 업무 연관성을 심사하는 과정으로, 사고성 재해는 자문의 소견으로, 직업성 질병은 업무상질병판정위원회를 거쳐 결정됩니다.',
          en: 'This is the process where the Korea Workers\' Compensation and Welfare Service reviews the connection to work. For accidental injuries, the decision is based on an advisory physician\'s opinion; for occupational diseases, it goes through the Occupational Disease Determination Committee.',
          zh: '这是勤劳福祉公团审查与工作关联性的过程：事故性灾害根据顾问医生的意见判定，职业性疾病则须经过职业病判定委员会审议决定。',
          vi: 'Đây là quá trình COMWEL thẩm định mối liên quan đến công việc: đối với tai nạn thì quyết định dựa trên ý kiến của bác sĩ tư vấn, còn bệnh nghề nghiệp phải qua Hội đồng thẩm định bệnh nghề nghiệp.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '작업 내용 설명서, 근무 시간표, 작업 환경 사진, 작업환경측정 결과',
                en: 'Description of work duties, work schedule, photos of the work environment, results of workplace environment measurements',
                zh: '工作内容说明书、工作时间表、作业环境照片、作业环境检测结果',
                vi: 'Bản mô tả nội dung công việc, lịch làm việc, ảnh môi trường làm việc, kết quả đo môi trường làm việc',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '요양으로 휴업한 기간과 그 후 30일 동안은 해고할 수 없습니다(근로기준법 제23조제2항).',
                en: 'You cannot be dismissed during the period of leave for medical care and for 30 days after it (Labor Standards Act Article 23, Paragraph 2).',
                zh: '在因疗养而停工的期间以及此后30天内，不得解雇（《劳动基准法》第23条第2款）。',
                vi: 'Không được sa thải trong thời gian nghỉ việc để điều dưỡng và 30 ngày sau đó (Điều 23 Khoản 2 Luật Tiêu chuẩn Lao động).',
              ),
              L10nText(
                ko: '산재를 신청했다는 이유로 인사상 불이익을 주거나 취하를 강요하는 것도 금지되어 있습니다. 그런 일이 생기면 고용노동청에 별도로 신고할 수 있습니다.',
                en: 'It is also prohibited to give you disadvantageous personnel treatment or pressure you to withdraw your claim because you filed for an industrial accident. If this happens, you can file a separate report with the employment and labor office.',
                zh: '也禁止以申请工伤为由给予人事上的不利待遇或强迫撤回申请。若发生此类情况，可另行向雇佣劳动厅举报。',
                vi: 'Cũng nghiêm cấm việc gây bất lợi về nhân sự hoặc ép buộc rút đơn vì lý do đã nộp đơn xin công nhận tai nạn lao động. Nếu xảy ra việc như vậy, bạn có thể trình báo riêng lên Sở Việc làm và Lao động.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '사업주 의견 제출',
              en: 'Employer\'s Submission of Opinion',
              zh: '雇主提交意见',
              vi: 'Người sử dụng lao động nộp ý kiến',
            ),
            bullets: [
              L10nText(
                ko: '근로복지공단은 조사 과정에서 사업주에게도 의견서를 요청합니다.',
                en: 'During the investigation, the Korea Workers\' Compensation and Welfare Service also requests a written opinion from the employer.',
                zh: '在调查过程中，勤劳福祉公团也会要求雇主提交意见书。',
                vi: 'Trong quá trình điều tra, COMWEL cũng sẽ yêu cầu người sử dụng lao động nộp ý kiến bằng văn bản.',
              ),
              L10nText(
                ko: '사업주 의견과 근로자 진술이 다르더라도, 제출된 증거와 정황을 종합해 판단합니다.',
                en: 'Even if the employer\'s opinion differs from the employee\'s statement, the decision is made by comprehensively weighing the submitted evidence and circumstances.',
                zh: '即使雇主意见与劳动者陈述不一致，也会综合提交的证据和情况作出判断。',
                vi: 'Ngay cả khi ý kiến của người sử dụng lao động khác với lời khai của người lao động, quyết định sẽ được đưa ra dựa trên việc xem xét tổng hợp bằng chứng và tình huống đã nộp.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '5단계: 승인과 보상',
          en: 'Step 5: Approval and Compensation',
          zh: '第五步：批准与补偿',
          vi: 'Bước 5: Phê duyệt và bồi thường',
        ),
        summary: L10nText(
          ko: '산재 승인 후 보상금을 수령하는 단계로, 요양급여 외에도 청구할 수 있는 급여가 여러 가지 있습니다.',
          en: 'This is the stage where you receive compensation after your industrial accident claim is approved. There are several types of benefits you can claim in addition to medical care benefits.',
          zh: '这一步是工伤获批后领取补偿金的阶段，除疗养给付外，还可以申请多种其他给付。',
          vi: 'Đây là giai đoạn nhận tiền bồi thường sau khi tai nạn lao động được công nhận; ngoài trợ cấp điều dưỡng còn có nhiều loại trợ cấp khác có thể yêu cầu.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '청구할 수 있는 급여',
              en: 'Benefits You Can Claim',
              zh: '可申请的给付项目',
              vi: 'Các loại trợ cấp có thể yêu cầu',
            ),
            bullets: [
              L10nText(
                ko: '요양비 청구서, 휴업급여 청구서, 간병 필요성 소견서, 진료계획서(치료 연장 시)',
                en: 'Medical care cost claim form, temporary disability benefit claim form, medical opinion on the need for nursing care, treatment plan (if extending treatment)',
                zh: '疗养费申请书、停工给付申请书、护理必要性意见书、诊疗计划书（延长治疗时）',
                vi: 'Đơn yêu cầu chi phí điều dưỡng, đơn yêu cầu trợ cấp nghỉ việc, giấy khám về sự cần thiết chăm sóc, kế hoạch điều trị (khi kéo dài điều trị)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '휴업급여는 평균임금의 70%로 알려져 있습니다.',
                en: 'Temporary disability benefit is understood to be 70% of the average wage.',
                zh: '据了解，停工给付为平均工资的70%。',
                vi: 'Trợ cấp nghỉ việc được biết là 70% mức lương trung bình.',
              ),
              L10nText(
                ko: '간병급여를 청구하려면 주치의의 간병 필요성 소견서가 반드시 있어야 합니다.',
                en: 'To claim nursing care benefits, you must have a medical opinion from your attending physician confirming the need for nursing care.',
                zh: '申请护理给付必须持有主治医生出具的护理必要性意见书。',
                vi: 'Để yêu cầu trợ cấp chăm sóc, bắt buộc phải có giấy khám xác nhận sự cần thiết chăm sóc do bác sĩ điều trị cấp.',
              ),
              L10nText(
                ko: '치료를 더 받아야 하면 병원이 진료계획서를 공단에 제출해야 기간이 연장됩니다.',
                en: 'If further treatment is needed, the hospital must submit a treatment plan to the corporation for the period to be extended.',
                zh: '如需继续治疗，须由医院向公团提交诊疗计划书，才能延长治疗期间。',
                vi: 'Nếu cần điều trị thêm, bệnh viện phải nộp kế hoạch điều trị cho cơ quan thì thời gian mới được gia hạn.',
              ),
              L10nText(
                ko: '장해가 남으면 치료 종결 후 장해급여를 별도로 신청합니다.',
                en: 'If a disability remains, apply separately for disability benefits after treatment ends.',
                zh: '若留有伤残，治疗结束后需另行申请伤残给付。',
                vi: 'Nếu để lại di chứng, sau khi kết thúc điều trị cần nộp đơn xin trợ cấp tàn tật riêng.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '장해급여',
              en: 'Disability Benefits',
              zh: '伤残给付',
              vi: 'Trợ cấp tàn tật',
            ),
            bullets: [
              L10nText(
                ko: '치료 종결 후에도 장해가 남으면 장해등급에 따라 장해급여를 별도로 신청할 수 있습니다.',
                en: 'If a disability remains even after treatment ends, you can apply separately for disability benefits according to your disability grade.',
                zh: '治疗结束后如仍留有伤残，可根据伤残等级另行申请伤残给付。',
                vi: 'Nếu sau khi kết thúc điều trị vẫn còn di chứng, có thể nộp đơn xin trợ cấp tàn tật riêng theo mức độ tàn tật.',
              ),
              L10nText(
                ko: '장해등급 판정을 위한 별도 진단서가 필요합니다.',
                en: 'A separate medical certificate is required for the disability grade determination.',
                zh: '进行伤残等级判定需要另外的诊断书。',
                vi: 'Cần có giấy chứng nhận y tế riêng để xác định mức độ tàn tật.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '6단계: 불승인 시 불복',
          en: 'Step 6: Appealing a Non-Approval Decision',
          zh: '第六步：对不予认定提出异议',
          vi: 'Bước 6: Khiếu nại khi không được công nhận',
        ),
        summary: L10nText(
          ko: '산재가 불승인되었을 때 이의를 제기하는 단계로, "심사청구 → 재심사청구 → 행정소송" 순서로 이어집니다.',
          en: 'This is the stage for objecting when your industrial accident claim is not approved, proceeding in the order "request for review → request for reexamination → administrative litigation."',
          zh: '这是在工伤未获认定时提出异议的阶段，程序按"审查请求→再审查请求→行政诉讼"的顺序进行。',
          vi: 'Đây là giai đoạn khiếu nại khi tai nạn lao động không được công nhận, tiến hành theo trình tự "yêu cầu thẩm định → yêu cầu tái thẩm định → khởi kiện hành chính".',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '준비할 서류',
              en: 'Documents to Prepare',
              zh: '需要准备的材料',
              vi: 'Giấy tờ cần chuẩn bị',
            ),
            bullets: [
              L10nText(
                ko: '불승인 결정 통지서, 심사청구서, 보완 전문의 소견서',
                en: 'Notice of non-approval decision, request for review, supplementary specialist medical opinion',
                zh: '不予认定决定通知书、审查请求书、补充专科医生意见书',
                vi: 'Thông báo quyết định không công nhận, đơn yêu cầu thẩm định, giấy khám bổ sung của bác sĩ chuyên khoa',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '유의사항',
              en: 'Points to Note',
              zh: '注意事项',
              vi: 'Lưu ý',
            ),
            bullets: [
              L10nText(
                ko: '심사청구와 재심사청구는 각각 결정을 안 날로부터 90일 안에 해야 하며, 기간을 넘기면 권리를 잃습니다.',
                en: 'Both the request for review and the request for reexamination must be filed within 90 days of learning of the decision — if you miss the deadline, you lose the right to appeal.',
                zh: '审查请求和再审查请求均须在得知决定之日起90天内提出，逾期将丧失该权利。',
                vi: 'Đơn yêu cầu thẩm định và tái thẩm định đều phải nộp trong vòng 90 ngày kể từ ngày biết quyết định; nếu quá hạn sẽ mất quyền khiếu nại.',
              ),
              L10nText(
                ko: '같은 자료로 다시 내면 결과가 잘 바뀌지 않으므로, 업무 관련성을 새로 보강할 자료나 전문의 소견을 추가해야 합니다.',
                en: 'Resubmitting the same materials rarely changes the outcome, so you should add new materials or a specialist opinion that further supports the work-relatedness of the accident.',
                zh: '若提交与之前相同的材料，结果很难改变，因此需要补充新的材料或专科医生意见来加强与工作的关联性。',
                vi: 'Nếu nộp lại cùng tài liệu như trước, kết quả khó thay đổi, vì vậy cần bổ sung tài liệu mới hoặc ý kiến bác sĩ chuyên khoa để củng cố mối liên quan đến công việc.',
              ),
              L10nText(
                ko: '사업주 과실이 있다면 근로복지공단 보상과 별개로 민사 손해배상을 함께 검토할 수 있습니다.',
                en: 'If the employer was at fault, you can also consider civil damages separately from the compensation from the Korea Workers\' Compensation and Welfare Service.',
                zh: '如果雇主存在过失，除勤劳福祉公团的补偿外，还可一并考虑提起民事损害赔偿。',
                vi: 'Nếu người sử dụng lao động có lỗi, ngoài khoản bồi thường từ COMWEL, bạn cũng có thể cân nhắc yêu cầu bồi thường thiệt hại dân sự.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '행정소송',
              en: 'Administrative Litigation',
              zh: '行政诉讼',
              vi: 'Khởi kiện hành chính',
            ),
            bullets: [
              L10nText(
                ko: '재심사청구에서도 불복되면 행정법원에 행정소송을 제기할 수 있습니다.',
                en: 'If the request for reexamination is also denied, you can file an administrative lawsuit with the administrative court.',
                zh: '如果再审查请求仍未获支持，可向行政法院提起行政诉讼。',
                vi: 'Nếu yêu cầu tái thẩm định vẫn không được chấp nhận, bạn có thể khởi kiện hành chính tại tòa án hành chính.',
              ),
              L10nText(
                ko: '이 단계부터는 변호사·노무사의 전문적인 조력을 받는 것이 좋으며, 대한법률구조공단 상담을 먼저 받아볼 수 있습니다.',
                en: 'From this stage on, it is advisable to get professional help from a lawyer or certified labor consultant, and you can first consult the Korea Legal Aid Corporation.',
                zh: '从这一阶段起，建议寻求律师或劳务士的专业协助，也可以先咨询大韩法律救助公团。',
                vi: 'Từ giai đoạn này, nên tìm sự hỗ trợ chuyên môn từ luật sư hoặc tư vấn viên lao động, và có thể tư vấn trước với Tổng công ty Hỗ trợ pháp lý Hàn Quốc.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '요양급여신청서 서식 미리보기',
          en: 'Preview: Application for Medical Care Benefits Form',
          zh: '预览：疗养给付申请书表格',
          vi: 'Xem trước: Mẫu đơn xin trợ cấp điều dưỡng',
        ),
        summary: L10nText(
          ko: '근로복지공단 별지 제2호 서식입니다. 의학적 판단과 재해조사 소견은 의사·조사관이 작성하는 영역입니다.',
          en: 'This is the Korea Workers\' Compensation and Welfare Service\'s Attachment Form No. 2. The medical assessment and accident investigation opinion sections are filled out by the doctor and investigator.',
          zh: '这是勤劳福祉公团附件第2号表格。医学判断和灾害调查意见部分由医生和调查员填写。',
          vi: 'Đây là Mẫu đính kèm số 2 của COMWEL. Phần đánh giá y khoa và ý kiến điều tra tai nạn do bác sĩ và điều tra viên điền.',
        ),
        form: FormPreview(
          title: L10nText(
            ko: '산업재해보상보험 요양급여신청서',
            en: 'Industrial Accident Compensation Insurance — Application for Medical Care Benefits',
            zh: '工伤保险疗养给付申请书',
            vi: 'Đơn xin trợ cấp điều dưỡng Bảo hiểm bồi thường tai nạn lao động',
          ),
          subtitle: L10nText(
            ko: '근로복지공단 지역본부(지사)장 귀하 · 별지 제2호 서식',
            en: 'To the Head of the Regional Headquarters (Branch) of the Korea Workers\' Compensation and Welfare Service · Attachment Form No. 2',
            zh: '致勤劳福祉公团地区总部（支社）长 · 附件第2号表格',
            vi: 'Kính gửi Trưởng Trụ sở khu vực (Chi nhánh) COMWEL · Mẫu đính kèm số 2',
          ),
          rows: [
            FormRowData.section(
              section: L10nText(
                ko: '재해자',
                en: 'Injured Worker',
                zh: '受灾者',
                vi: 'Người bị tai nạn',
              ),
              sub: L10nText(
                ko: '굵은 선 안은 필수 기재',
                en: 'Items inside the bold border are required',
                zh: '粗线框内为必填项',
                vi: 'Mục trong khung viền đậm là bắt buộc phải điền',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '성명(영문 대문자)',
                en: 'Name (in Capital English Letters)',
                zh: '姓名（英文大写）',
                vi: 'Họ tên (viết hoa bằng tiếng Anh)',
              ),
              value: L10nText(
                ko: '외국인등록증상 영문명 대문자',
                en: 'Capital-letter English name as shown on your Alien Registration Card',
                zh: '外国人登录证上的英文姓名大写',
                vi: 'Tên tiếng Anh viết hoa theo Thẻ đăng ký người nước ngoài',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '외국인등록번호',
                en: 'Alien Registration Number',
                zh: '外国人登录号',
                vi: 'Số đăng ký người nước ngoài',
              ),
              value: L10nText(
                ko: '프로필에서 자동 입력',
                en: 'Auto-filled from your profile',
                zh: '从个人资料中自动填写',
                vi: 'Tự động điền từ hồ sơ cá nhân',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '주소 · 휴대전화',
                en: 'Address · Mobile Phone',
                zh: '地址·手机号码',
                vi: 'Địa chỉ · Số điện thoại di động',
              ),
              value: L10nText(
                ko: '프로필 체류지 주소와 연락처',
                en: 'Your registered address of stay and contact number from your profile',
                zh: '个人资料中的居留地址和联系方式',
                vi: 'Địa chỉ cư trú và số liên lạc trong hồ sơ cá nhân',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '채용일자 · 직종',
                en: 'Date of Hire · Occupation',
                zh: '录用日期·工种',
                vi: 'Ngày tuyển dụng · Ngành nghề',
              ),
              value: L10nText(
                ko: '근로계약서에서 읽어옴',
                en: 'Read from your employment contract',
                zh: '从劳动合同中读取',
                vi: 'Lấy từ hợp đồng lao động',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '재해발생 일시(분 단위)',
                en: 'Date and Time of the Accident (to the Minute)',
                zh: '灾害发生时间（精确到分钟）',
                vi: 'Ngày giờ xảy ra tai nạn (chính xác đến phút)',
              ),
              value: L10nText(
                ko: '근무기록에서 가져옴',
                en: 'Pulled from your work records',
                zh: '从工作记录中获取',
                vi: 'Lấy từ hồ sơ làm việc',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '출근 · 퇴근시간',
                en: 'Clock-In · Clock-Out Time',
                zh: '上班·下班时间',
                vi: 'Giờ vào làm · Giờ tan làm',
              ),
              value: L10nText(
                ko: '그날의 근무기록에서 가져옴',
                en: 'Pulled from that day\'s work record',
                zh: '从当天的工作记录中获取',
                vi: 'Lấy từ hồ sơ làm việc ngày hôm đó',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '근로자 유형 · 신청 구분',
                en: 'Worker Type · Application Category',
                zh: '劳动者类型·申请类别',
                vi: 'Loại người lao động · Phân loại đơn xin',
              ),
              value: L10nText(
                ko: '근로자 · 업무상 사고(앞 단계 선택 반영)',
                en: 'Employee · Occupational accident (reflects your selection from the earlier step)',
                zh: '劳动者·业务上事故（沿用前一步骤的选择）',
                vi: 'Người lao động · Tai nạn liên quan đến công việc (phản ánh lựa chọn ở bước trước)',
              ),
              tag: 'auto',
            ),
            FormRowData.section(
              section: L10nText(
                ko: '사업장',
                en: 'Workplace',
                zh: '事业场',
                vi: 'Nơi làm việc',
              ),
              sub: L10nText(
                ko: '사업장 정보',
                en: 'Workplace information',
                zh: '事业场信息',
                vi: 'Thông tin nơi làm việc',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '사업장명 · 사업주명 · 연락처',
                en: 'Workplace Name · Employer Name · Contact Number',
                zh: '单位名称·雇主姓名·联系方式',
                vi: 'Tên nơi làm việc · Tên người sử dụng lao động · Số liên lạc',
              ),
              value: L10nText(
                ko: '근무지 등록 정보에서 가져옴',
                en: 'Pulled from your registered workplace information',
                zh: '从工作单位登记信息中获取',
                vi: 'Lấy từ thông tin nơi làm việc đã đăng ký',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '사업장관리번호',
                en: 'Workplace Management Number',
                zh: '事业场管理编号',
                vi: 'Mã số quản lý nơi làm việc',
              ),
              value: L10nText(
                ko: '근로복지공단 홈페이지 민원조회에서 검색 후 직접 입력',
                en: 'Look it up on the Korea Workers\' Compensation and Welfare Service website\'s civil service lookup, then enter it manually',
                zh: '在勤劳福祉公团官网的民愿查询中搜索后手动填写',
                vi: 'Tra cứu tại mục tra cứu dân nguyện trên trang web COMWEL rồi tự nhập',
              ),
              tag: 'blank',
            ),
            FormRowData.section(
              section: L10nText(
                ko: '재해 발생 경위',
                en: 'Circumstances of the Accident',
                zh: '灾害发生经过',
                vi: 'Diễn biến xảy ra tai nạn',
              ),
              sub: L10nText(
                ko: '육하원칙 · 별지 사용 가능',
                en: 'Follow the 5W1H format · a separate sheet may be used',
                zh: '按六何原则填写·可另附页说明',
                vi: 'Theo nguyên tắc 5W1H · có thể dùng thêm giấy đính kèm',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '재해 발생 경위',
                en: 'Circumstances of the Accident',
                zh: '灾害发生经过',
                vi: 'Diễn biến xảy ra tai nạn',
              ),
              value: L10nText(
                ko: '2단계에서 적은 내용 그대로',
                en: 'Exactly as written in Step 2',
                zh: '按第二步所写内容原样填写',
                vi: 'Giống nguyên văn nội dung đã viết ở Bước 2',
              ),
              tag: 'raw',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '경찰 · 119 · 보험사 신고',
                en: 'Report to Police · 119 · Insurance Company',
                zh: '报警·119·保险公司报案',
                vi: 'Báo cảnh sát · 119 · Công ty bảo hiểm',
              ),
              value: L10nText(
                ko: '앞 단계 체크 결과 반영',
                en: 'Reflects the check result from the earlier step',
                zh: '沿用前一步骤的勾选结果',
                vi: 'Phản ánh kết quả đã chọn ở bước trước',
              ),
              tag: 'auto',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '목격자(성명·연락처·관계)',
                en: 'Witness (Name · Contact Number · Relationship)',
                zh: '目击者（姓名·联系方式·关系）',
                vi: 'Nhân chứng (Họ tên · Số liên lạc · Mối quan hệ)',
              ),
              value: L10nText(
                ko: '직접 입력',
                en: 'Enter manually',
                zh: '手动填写',
                vi: 'Tự nhập',
              ),
              tag: 'blank',
            ),
            FormRowData.section(
              section: L10nText(
                ko: '의료기관',
                en: 'Medical Institution',
                zh: '医疗机构',
                vi: 'Cơ sở y tế',
              ),
              sub: L10nText(
                ko: '현재 요양 중 / 이전 진료',
                en: 'Currently receiving care / previous treatment',
                zh: '当前疗养中／既往诊疗',
                vi: 'Đang điều dưỡng / đã khám trước đó',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '의료기관명 · 소재지',
                en: 'Medical Institution Name · Location',
                zh: '医疗机构名称·所在地',
                vi: 'Tên cơ sở y tế · Địa điểm',
              ),
              value: L10nText(
                ko: '산재보험 지정 의료기관인지 먼저 확인',
                en: 'First check whether it is a medical institution designated for industrial accident insurance',
                zh: '请先确认是否为工伤保险指定医疗机构',
                vi: 'Trước tiên hãy kiểm tra xem đây có phải cơ sở y tế được chỉ định cho bảo hiểm tai nạn lao động hay không',
              ),
              tag: 'blank',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '대행 제출 위임',
                en: 'Authorization for Proxy Submission',
                zh: '委托代为提交',
                vi: 'Ủy quyền nộp thay',
              ),
              value: L10nText(
                ko: '병원에 맡기려면 이 칸에 서명',
                en: 'Sign here if you want the hospital to submit it on your behalf',
                zh: '若委托医院代为提交，请在此栏签字',
                vi: 'Nếu muốn ủy quyền cho bệnh viện nộp thay, hãy ký vào ô này',
              ),
              tag: 'blank',
            ),
            FormRowData.section(
              section: L10nText(
                ko: '별지 제3호 · 요양급여신청 소견서',
                en: 'Attachment Form No. 3 · Medical Opinion for Application for Medical Care Benefits',
                zh: '附件第3号·疗养给付申请意见书',
                vi: 'Mẫu đính kèm số 3 · Giấy khám xin trợ cấp điều dưỡng',
              ),
              sub: L10nText(
                ko: '주치의가 작성하는 부분',
                en: 'This section is filled out by your attending physician',
                zh: '此部分由主治医生填写',
                vi: 'Phần này do bác sĩ điều trị điền',
              ),
            ),
            FormRowData.field(
              label: L10nText(
                ko: '상병명 · 상병코드(KCD)',
                en: 'Diagnosis · Diagnosis Code (KCD)',
                zh: '病名·疾病代码（KCD）',
                vi: 'Tên bệnh · Mã bệnh (KCD)',
              ),
              value: L10nText(
                ko: '의사가 작성',
                en: 'Filled out by the doctor',
                zh: '由医生填写',
                vi: 'Do bác sĩ điền',
              ),
              tag: 'blank',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '입원 · 통원 예상기간',
                en: 'Expected Period of Hospitalization · Outpatient Care',
                zh: '预计住院·门诊治疗期间',
                vi: 'Thời gian dự kiến nằm viện · Điều trị ngoại trú',
              ),
              value: L10nText(
                ko: '의사가 작성',
                en: 'Filled out by the doctor',
                zh: '由医生填写',
                vi: 'Do bác sĩ điền',
              ),
              tag: 'blank',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '취업치료 가능 여부',
                en: 'Whether Treatment While Working Is Possible',
                zh: '是否可边工作边治疗',
                vi: 'Có thể vừa làm việc vừa điều trị hay không',
              ),
              value: L10nText(
                ko: '의사의 의학적 판단',
                en: 'The doctor\'s medical judgment',
                zh: '医生的医学判断',
                vi: 'Đánh giá y khoa của bác sĩ',
              ),
              tag: 'blank',
            ),
            FormRowData.field(
              label: L10nText(
                ko: '재해조사 소견',
                en: 'Accident Investigation Opinion',
                zh: '灾害调查意见',
                vi: 'Ý kiến điều tra tai nạn',
              ),
              value: L10nText(
                ko: '근로복지공단 조사관이 작성',
                en: 'Filled out by the Korea Workers\' Compensation and Welfare Service investigator',
                zh: '由勤劳福祉公团调查员填写',
                vi: 'Do điều tra viên COMWEL điền',
              ),
              tag: 'blank',
            ),
          ],
        ),
      ),
    ],
  ),
  12: CategoryDetail(
    pages: [
      BookPage(
        title: L10nText(
          ko: '중앙정부·전국 공공기관',
          en: 'Central Government and Nationwide Public Agencies',
          zh: '中央政府·全国性公共机构',
          vi: 'Chính phủ trung ương và các cơ quan công quyền toàn quốc',
        ),
        summary: L10nText(
          ko: '비자·체류는 법무부, 임금·근로조건은 고용노동부, 고용허가제는 한국산업인력공단, 산재는 근로복지공단이 각각 담당합니다.',
          en: 'Visas and sojourn are handled by the Ministry of Justice, wages and working conditions by the Ministry of Employment and Labor, the Employment Permit System by the Human Resources Development Service of Korea, and industrial accidents by the Korea Workers\' Compensation and Welfare Service.',
          zh: '签证和居留由法务部负责，工资和劳动条件由雇佣劳动部负责，雇佣许可制由韩国产业人力公团负责，工伤则由勤劳福祉公团负责。',
          vi: 'Visa và cư trú do Bộ Tư pháp phụ trách, tiền lương và điều kiện lao động do Bộ Việc làm và Lao động phụ trách, Chế độ Cấp phép Việc làm do Cơ quan Phát triển Nguồn nhân lực Hàn Quốc phụ trách, và tai nạn lao động do COMWEL phụ trách.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '비자·체류',
              en: 'Visa and Sojourn',
              zh: '签证·居留',
              vi: 'Visa và cư trú',
            ),
            bullets: [
              L10nText(
                ko: '법무부 외국인종합안내센터: 1345 (09:00~22:00, 최대 20개 언어 / 18:00~22:00는 한국어·중국어·영어만 가능)',
                en: 'Ministry of Justice Foreigner Comprehensive Information Center: 1345 (09:00–22:00, up to 20 languages / only Korean, Chinese, and English from 18:00–22:00)',
                zh: '法务部外国人综合咨询中心：1345（09:00~22:00，最多提供20种语言 / 18:00~22:00仅提供韩语、中文、英语）',
                vi: 'Trung tâm hướng dẫn tổng hợp cho người nước ngoài của Bộ Tư pháp: 1345 (09:00~22:00, tối đa 20 ngôn ngữ / từ 18:00~22:00 chỉ có tiếng Hàn, tiếng Trung, tiếng Anh)',
              ),
              L10nText(
                ko: '하이코리아: hikorea.go.kr (온라인 민원 포털)',
                en: 'HiKorea: hikorea.go.kr (online civil service portal)',
                zh: 'HiKorea：hikorea.go.kr（在线民愿服务门户）',
                vi: 'HiKorea: hikorea.go.kr (cổng dân nguyện trực tuyến)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '노동·산재',
              en: 'Labor and Industrial Accidents',
              zh: '劳动·工伤',
              vi: 'Lao động · Tai nạn lao động',
            ),
            bullets: [
              L10nText(
                ko: '고용노동부 고객상담센터: 1350 (임금체불, 근로조건, 직장 내 문제 전반)',
                en: 'Ministry of Employment and Labor Customer Service Center: 1350 (unpaid wages, working conditions, and workplace issues in general)',
                zh: '雇佣劳动部客服中心：1350（拖欠工资、劳动条件及各类职场问题）',
                vi: 'Trung tâm tư vấn khách hàng Bộ Việc làm và Lao động: 1350 (nợ lương, điều kiện lao động và các vấn đề tại nơi làm việc nói chung)',
              ),
              L10nText(
                ko: '한국산업인력공단 EPS 외국인근로자 상담센터: 1577-0071 (평일 09:00~18:00, 15개 언어)',
                en: 'Human Resources Development Service of Korea EPS Foreign Worker Counseling Center: 1577-0071 (weekdays 09:00–18:00, 15 languages)',
                zh: '韩国产业人力公团EPS外国劳动者咨询中心：1577-0071（工作日09:00~18:00，提供15种语言）',
                vi: 'Trung tâm tư vấn lao động nước ngoài EPS của Cơ quan Phát triển Nguồn nhân lực Hàn Quốc: 1577-0071 (ngày thường 09:00~18:00, 15 ngôn ngữ)',
              ),
              L10nText(
                ko: '근로복지공단: 1588-0075 (산재보험 관련 상담 및 관할 지사 안내)',
                en: 'Korea Workers\' Compensation and Welfare Service: 1588-0075 (industrial accident insurance counseling and guidance to the branch with jurisdiction)',
                zh: '勤劳福祉公团：1588-0075（工伤保险相关咨询及管辖分社指引）',
                vi: 'COMWEL: 1588-0075 (tư vấn về bảo hiểm tai nạn lao động và hướng dẫn chi nhánh có thẩm quyền)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '여성 근로자 특화 상담',
              en: 'Counseling Specialized for Women Workers',
              zh: '女性劳动者专项咨询',
              vi: 'Tư vấn chuyên biệt cho lao động nữ',
            ),
            bullets: [
              L10nText(
                ko: '여성긴급전화 1366: 성희롱·가정폭력 등 여성 대상 긴급 상담 (24시간, 다국어 통역 연계 가능)',
                en: 'Women\'s Emergency Hotline 1366: emergency counseling for women on issues such as sexual harassment and domestic violence (24 hours, multilingual interpretation available)',
                zh: '女性紧急热线1366：为女性提供性骚扰、家庭暴力等紧急咨询（24小时，可连接多语种口译）',
                vi: 'Đường dây nóng khẩn cấp dành cho phụ nữ 1366: tư vấn khẩn cấp cho phụ nữ về quấy rối tình dục, bạo lực gia đình, v.v. (24 giờ, có thể kết nối phiên dịch đa ngôn ngữ)',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '광역 지자체 지원망 (경기도)',
          en: 'Provincial Support Network (Gyeonggi Province)',
          zh: '广域自治团体支援网络（京畿道）',
          vi: 'Mạng lưới hỗ trợ chính quyền địa phương cấp tỉnh (tỉnh Gyeonggi)',
        ),
        summary: L10nText(
          ko: '경기도는 노동권익센터를 통해 임금체불·부당해고 등 노동 상담을 지역별로 제공합니다.',
          en: 'Gyeonggi Province provides regional labor counseling on matters such as unpaid wages and unfair dismissal through its Labor Rights Centers.',
          zh: '京畿道通过劳动权益中心按地区提供拖欠工资、非法解雇等劳动咨询服务。',
          vi: 'Tỉnh Gyeonggi cung cấp dịch vụ tư vấn lao động theo khu vực về nợ lương, sa thải trái pháp luật, v.v. thông qua Trung tâm Quyền lợi Lao động.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '경기도노동권익센터 남부센터',
              en: 'Gyeonggi Labor Rights Center — Southern Branch',
              zh: '京畿道劳动权益中心 南部中心',
              vi: 'Trung tâm Quyền lợi Lao động Gyeonggi — Chi nhánh phía Nam',
            ),
            bullets: [
              L10nText(
                ko: '전화: 031-8030-4541',
                en: 'Phone: 031-8030-4541',
                zh: '电话：031-8030-4541',
                vi: 'Điện thoại: 031-8030-4541',
              ),
              L10nText(
                ko: '위치: 경기도 수원시 팔달구 덕영대로 924, 수원역 2층',
                en: 'Address: 2F, Suwon Station, 924 Deogyeong-daero, Paldal-gu, Suwon-si, Gyeonggi-do',
                zh: '地址：京畿道水原市八达区德荣大路924号，水原站2楼',
                vi: 'Địa chỉ: Tầng 2 Ga Suwon, 924 Deogyeong-daero, Paldal-gu, Suwon-si, Gyeonggi-do',
              ),
              L10nText(
                ko: '운영시간: 평일(공휴일 제외) 09:30~11:30, 13:30~17:30',
                en: 'Hours: weekdays (excluding public holidays) 09:30–11:30, 13:30–17:30',
                zh: '营业时间：工作日（公休日除外）09:30~11:30，13:30~17:30',
                vi: 'Giờ hoạt động: ngày thường (trừ ngày lễ) 09:30~11:30, 13:30~17:30',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '이용 방법',
              en: 'How to Use',
              zh: '使用方法',
              vi: 'Cách sử dụng',
            ),
            bullets: [
              L10nText(
                ko: '방문 상담 전 전화로 예약하는 것을 권장합니다.',
                en: 'It is recommended to make a phone reservation before visiting in person.',
                zh: '建议在到访咨询前先电话预约。',
                vi: 'Nên đặt lịch hẹn qua điện thoại trước khi đến tư vấn trực tiếp.',
              ),
              L10nText(
                ko: '임금체불(⑩)·근로계약(⑨) 상담 시 근로계약서·임금명세서·통장내역을 지참하면 상담이 빠릅니다.',
                en: 'For unpaid wages (⑩) or employment contract (⑨) counseling, bringing your employment contract, pay stub, and bank statement will speed up the consultation.',
                zh: '咨询拖欠工资（⑩）或劳动合同（⑨）问题时，携带劳动合同、工资明细单和银行流水可加快咨询速度。',
                vi: 'Khi tư vấn về nợ lương (⑩) hoặc hợp đồng lao động (⑨), nếu mang theo hợp đồng lao động, bảng lương và sao kê tài khoản thì việc tư vấn sẽ nhanh hơn.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '경기지방노동위원회',
              en: 'Gyeonggi Regional Labor Relations Commission',
              zh: '京畿地方劳动委员会',
              vi: 'Ủy ban Quan hệ Lao động Khu vực Gyeonggi',
            ),
            bullets: [
              L10nText(
                ko: '부당해고·부당노동행위 등은 경기지방노동위원회에 구제신청을 할 수 있습니다.',
                en: 'For unfair dismissal or unfair labor practices, you can file a request for remedy with the Gyeonggi Regional Labor Relations Commission.',
                zh: '对于非法解雇、不当劳动行为等，可向京畿地方劳动委员会提出救济申请。',
                vi: 'Đối với sa thải trái pháp luật, hành vi lao động không công bằng, v.v., bạn có thể nộp đơn xin cứu trợ lên Ủy ban Quan hệ Lao động Khu vực Gyeonggi.',
              ),
              L10nText(
                ko: '신청 기한은 부당해고 등이 있었던 날로부터 3개월 이내입니다.',
                en: 'The filing deadline is within 3 months from the date of the unfair dismissal, etc.',
                zh: '申请期限为非法解雇等发生之日起3个月以内。',
                vi: 'Thời hạn nộp đơn là trong vòng 3 tháng kể từ ngày xảy ra việc sa thải trái pháp luật, v.v.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '수원시 관내 밀착 지원기관',
          en: 'Close-to-You Support Organizations in Suwon',
          zh: '水原市辖区内密切支援机构',
          vi: 'Các cơ quan hỗ trợ sát sao tại thành phố Suwon',
        ),
        summary: L10nText(
          ko: '수원시에는 외국인 생활 전반을 모국어로 상담해주는 기관과 비정규직·이주노동자 전담 기관이 함께 있습니다.',
          en: 'Suwon has both organizations that provide counseling in your native language on daily life as a foreigner, and organizations dedicated to non-regular and migrant workers.',
          zh: '水原市既有可用母语咨询外国人日常生活各方面问题的机构，也有专门服务非正规就业者和移民劳动者的机构。',
          vi: 'Thành phố Suwon có cả các cơ quan tư vấn bằng tiếng mẹ đẻ về đời sống nói chung của người nước ngoài lẫn các cơ quan chuyên trách cho lao động phi chính quy và lao động di trú.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '수원시 외국인복지센터',
              en: 'Suwon Foreigner Welfare Center',
              zh: '水原市外国人福祉中心',
              vi: 'Trung tâm Phúc lợi Người nước ngoài thành phố Suwon',
            ),
            bullets: [
              L10nText(
                ko: '전화: 031-224-6691',
                en: 'Phone: 031-224-6691',
                zh: '电话：031-224-6691',
                vi: 'Điện thoại: 031-224-6691',
              ),
              L10nText(
                ko: '위치: 경기도 수원시 팔달구 행궁로 77, 6층',
                en: 'Address: 6F, 77 Haenggung-ro, Paldal-gu, Suwon-si, Gyeonggi-do',
                zh: '地址：京畿道水原市八达区行宫路77号6楼',
                vi: 'Địa chỉ: Tầng 6, 77 Haenggung-ro, Paldal-gu, Suwon-si, Gyeonggi-do',
              ),
              L10nText(
                ko: '베트남어·중국어 등 모국어 상담원이 배치되어 있습니다.',
                en: 'Native-language counselors in Vietnamese, Chinese, and other languages are available.',
                zh: '配有越南语、中文等母语咨询员。',
                vi: 'Có bố trí nhân viên tư vấn bằng tiếng mẹ đẻ như tiếng Việt, tiếng Trung, v.v.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '그 밖의 수원시 기관',
              en: 'Other Suwon Organizations',
              zh: '其他水原市机构',
              vi: 'Các cơ quan khác tại Suwon',
            ),
            bullets: [
              L10nText(
                ko: '경기도이민사회통합지원센터 수원센터: 031-257-1841 (체류·정착 상담)',
                en: 'Gyeonggi-do Immigrant Social Integration Support Center, Suwon Branch: 031-257-1841 (sojourn and settlement counseling)',
                zh: '京畿道移民社会融合支援中心 水原中心：031-257-1841（居留·定居咨询）',
                vi: 'Trung tâm Hỗ trợ Hòa nhập Xã hội cho Người nhập cư tỉnh Gyeonggi, Chi nhánh Suwon: 031-257-1841 (tư vấn cư trú và ổn định cuộc sống)',
              ),
              L10nText(
                ko: '수원시비정규직노동자복지센터: 031-548-1888 (경기도 수원시 장안구 덕영대로559, 수원시노동자종합복지관 2층) — 이주민 무료 법률상담도 정기 운영합니다.',
                en: 'Suwon Non-Regular Workers Welfare Center: 031-548-1888 (2F, Suwon Workers\' General Welfare Center, 559 Deogyeong-daero, Jangan-gu, Suwon-si, Gyeonggi-do) — also regularly runs free legal counseling for migrants.',
                zh: '水原市非正规就业劳动者福祉中心：031-548-1888（京畿道水原市长安区德荣大路559号，水原市劳动者综合福祉馆2楼）——也定期为移民提供免费法律咨询。',
                vi: 'Trung tâm Phúc lợi Lao động Phi chính quy thành phố Suwon: 031-548-1888 (Tầng 2 Trung tâm Phúc lợi Tổng hợp Người lao động Suwon, 559 Deogyeong-daero, Jangan-gu, Suwon-si, Gyeonggi-do) — cũng thường xuyên tổ chức tư vấn pháp lý miễn phí cho người di cư.',
              ),
              L10nText(
                ko: '수원시청 마을변호사·마을노무사 제도: 수원시청 또는 동주민센터에서 연계 신청 가능',
                en: 'Suwon City Hall Village Lawyer / Village Labor Consultant Program: you can apply for a referral at Suwon City Hall or your local community center (dong office)',
                zh: '水原市厅"村庄律师·村庄劳务士"制度：可在水原市厅或洞居民中心申请对接',
                vi: 'Chương trình Luật sư/Tư vấn viên lao động cộng đồng của Tòa thị chính Suwon: có thể đăng ký kết nối tại Tòa thị chính Suwon hoặc trung tâm hành chính phường (dong)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '찾아가는 이주민 무료 법률상담',
              en: 'Outreach Free Legal Counseling for Migrants',
              zh: '上门为移民提供的免费法律咨询',
              vi: 'Tư vấn pháp lý miễn phí lưu động cho người di cư',
            ),
            bullets: [
              L10nText(
                ko: '수원시비정규직노동자복지센터가 이주민 대상 무료 법률상담을 정기적으로 운영합니다.',
                en: 'The Suwon Non-Regular Workers Welfare Center regularly runs free legal counseling for migrants.',
                zh: '水原市非正规就业劳动者福祉中心定期为移民举办免费法律咨询。',
                vi: 'Trung tâm Phúc lợi Lao động Phi chính quy thành phố Suwon thường xuyên tổ chức tư vấn pháp lý miễn phí dành cho người di cư.',
              ),
              L10nText(
                ko: '일정은 수원시 또는 센터 채널을 통해 사전 공지됩니다.',
                en: 'The schedule is announced in advance through Suwon City or the center\'s channels.',
                zh: '具体日程会通过水原市或中心渠道提前公告。',
                vi: 'Lịch trình sẽ được thông báo trước qua thành phố Suwon hoặc các kênh của trung tâm.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '법률구조 및 무료소송 기관',
          en: 'Legal Aid and Free Litigation Organizations',
          zh: '法律救助及免费诉讼机构',
          vi: 'Cơ quan hỗ trợ pháp lý và kiện tụng miễn phí',
        ),
        summary: L10nText(
          ko: '소득이 일정 기준 이하라면 대한법률구조공단에서 상담부터 소송대리까지 무료로 지원받을 수 있습니다.',
          en: 'If your income is below a certain threshold, the Korea Legal Aid Corporation can provide free support ranging from consultation to litigation representation.',
          zh: '如果收入低于一定标准，可从大韩法律救助公团获得从咨询到诉讼代理的全程免费支持。',
          vi: 'Nếu thu nhập dưới một mức nhất định, bạn có thể được Tổng công ty Hỗ trợ pháp lý Hàn Quốc hỗ trợ miễn phí từ tư vấn đến đại diện tố tụng.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '대한법률구조공단',
              en: 'Korea Legal Aid Corporation',
              zh: '大韩法律救助公团',
              vi: 'Tổng công ty Hỗ trợ pháp lý Hàn Quốc',
            ),
            bullets: [
              L10nText(
                ko: '전화: 132 (전국 국번 없이, 무료)',
                en: 'Phone: 132 (no area code needed nationwide, free)',
                zh: '电话：132（全国范围无需区号，免费）',
                vi: 'Điện thoại: 132 (không cần mã vùng, gọi miễn phí trên toàn quốc)',
              ),
              L10nText(
                ko: '수원지부: 수원지방법원 인근 소재 — 정확한 주소는 klac.or.kr에서 확인',
                en: 'Suwon Branch: located near the Suwon District Court — check the exact address at klac.or.kr',
                zh: '水原分部：位于水原地方法院附近——具体地址请在klac.or.kr确认',
                vi: 'Chi nhánh Suwon: nằm gần Tòa án Quận Suwon — kiểm tra địa chỉ chính xác tại klac.or.kr',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '지원 대상과 범위',
              en: 'Eligibility and Scope of Support',
              zh: '支援对象及范围',
              vi: 'Đối tượng và phạm vi hỗ trợ',
            ),
            bullets: [
              L10nText(
                ko: '기준 중위소득 50% 이하(기초생활수급자, 임금체불 근로자 등)는 전액 무료',
                en: 'Fully free for those at or below 50% of the standard median income (basic livelihood recipients, workers with unpaid wages, etc.)',
                zh: '基准中位收入50%以下（基础生活保障对象、被拖欠工资的劳动者等）全程免费',
                vi: 'Miễn phí hoàn toàn cho người có thu nhập từ 50% thu nhập trung vị chuẩn trở xuống (người hưởng trợ cấp sinh hoạt cơ bản, người lao động bị nợ lương, v.v.)',
              ),
              L10nText(
                ko: '기준 중위소득 125% 이하는 변호사 보수를 제외한 소송비용만 본인 부담',
                en: 'For those at or below 125% of the standard median income, you only pay the litigation costs excluding attorney fees',
                zh: '基准中位收入125%以下，仅需自行承担除律师费以外的诉讼费用',
                vi: 'Người có thu nhập từ 125% thu nhập trung vị chuẩn trở xuống chỉ phải tự chi trả án phí, không bao gồm thù lao luật sư',
              ),
              L10nText(
                ko: '소득 기준은 매년 바뀌므로 신청 전 132로 확인하는 것이 정확합니다.',
                en: 'Since the income threshold changes every year, it is best to confirm by calling 132 before applying.',
                zh: '收入标准每年都会变化，申请前请拨打132确认以确保准确。',
                vi: 'Vì tiêu chuẩn thu nhập thay đổi hằng năm, nên gọi 132 để xác nhận trước khi nộp đơn cho chính xác.',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '온라인 법률상담',
              en: 'Online Legal Counseling',
              zh: '在线法律咨询',
              vi: 'Tư vấn pháp lý trực tuyến',
            ),
            bullets: [
              L10nText(
                ko: '대한법률구조공단 홈페이지(klac.or.kr)에서 사이버 상담을 신청하면 방문 없이도 답변을 받을 수 있습니다.',
                en: 'By requesting cyber counseling on the Korea Legal Aid Corporation website (klac.or.kr), you can get an answer without visiting in person.',
                zh: '在大韩法律救助公团官网（klac.or.kr）申请网络咨询，无需到访即可获得答复。',
                vi: 'Nếu đăng ký tư vấn trực tuyến trên trang web Tổng công ty Hỗ trợ pháp lý Hàn Quốc (klac.or.kr), bạn có thể nhận được câu trả lời mà không cần đến trực tiếp.',
              ),
            ],
          ),
        ],
      ),
      BookPage(
        title: L10nText(
          ko: '다국어·긴급 상담 창구',
          en: 'Multilingual and Emergency Counseling Channels',
          zh: '多语种·紧急咨询窗口',
          vi: 'Kênh tư vấn đa ngôn ngữ và khẩn cấp',
        ),
        summary: L10nText(
          ko: '언어 장벽이 걱정될 때는 무료 통역이 연결되는 창구부터 이용하는 것이 가장 빠릅니다.',
          en: 'If you are worried about the language barrier, the fastest option is to start with a channel that connects you to free interpretation.',
          zh: '如果担心语言障碍，最快的方法是先使用能连接免费口译的窗口。',
          vi: 'Nếu lo lắng về rào cản ngôn ngữ, cách nhanh nhất là sử dụng trước các kênh có kết nối phiên dịch miễn phí.',
        ),
        blocks: [
          ContentBlock(
            title: L10nText(
              ko: '생활 다국어 상담',
              en: 'Multilingual Daily Life Counseling',
              zh: '生活多语种咨询',
              vi: 'Tư vấn đời sống đa ngôn ngữ',
            ),
            bullets: [
              L10nText(
                ko: '다누리콜센터: 1577-1366 (다문화가족·이주여성 생활 상담, 다국어)',
                en: 'Danuri Call Center: 1577-1366 (daily life counseling for multicultural families and migrant women, multilingual)',
                zh: '多努力呼叫中心：1577-1366（多文化家庭·移民女性生活咨询，多语种）',
                vi: 'Tổng đài Danuri: 1577-1366 (tư vấn đời sống cho gia đình đa văn hóa, phụ nữ di cư, đa ngôn ngữ)',
              ),
              L10nText(
                ko: 'BBB코리아 전화통역: 1588-5644 (20개 언어, 24시간, 무료 3자 통화 통역)',
                en: 'BBB Korea Phone Interpretation: 1588-5644 (20 languages, 24 hours, free three-way call interpretation)',
                zh: 'BBB Korea电话口译：1588-5644（20种语言，24小时，免费三方通话口译）',
                vi: 'Phiên dịch qua điện thoại BBB Korea: 1588-5644 (20 ngôn ngữ, 24 giờ, phiên dịch cuộc gọi ba bên miễn phí)',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '긴급 상황',
              en: 'Emergency Situations',
              zh: '紧急情况',
              vi: 'Tình huống khẩn cấp',
            ),
            bullets: [
              L10nText(
                ko: '범죄·사고 신고: 112(경찰), 119(소방·구급)',
                en: 'Report a crime or accident: 112 (police), 119 (fire/paramedic)',
                zh: '报案·事故报告：112（警察）、119（消防·急救）',
                vi: 'Trình báo tội phạm, tai nạn: 112 (cảnh sát), 119 (cứu hỏa/cấp cứu)',
              ),
              L10nText(
                ko: '인권침해·긴급 노동상담: 법무부 1345, 고용노동부 1350',
                en: 'Human rights violations / urgent labor counseling: Ministry of Justice 1345, Ministry of Employment and Labor 1350',
                zh: '侵犯人权·紧急劳动咨询：法务部1345，雇佣劳动部1350',
                vi: 'Vi phạm nhân quyền / tư vấn lao động khẩn cấp: Bộ Tư pháp 1345, Bộ Việc làm và Lao động 1350',
              ),
            ],
          ),
          ContentBlock(
            title: L10nText(
              ko: '노동 관련 온라인 신고',
              en: 'Online Labor-Related Reporting',
              zh: '劳动相关在线举报',
              vi: 'Trình báo trực tuyến liên quan đến lao động',
            ),
            bullets: [
              L10nText(
                ko: '고용노동부 홈페이지의 [민원마당]에서 온라인으로도 각종 신고·진정 접수가 가능합니다.',
                en: 'You can also file various reports and petitions online through the [Civil Service Portal] on the Ministry of Employment and Labor website.',
                zh: '在雇佣劳动部官网的[民愿广场]中，也可在线提交各类举报和陈情。',
                vi: 'Bạn cũng có thể nộp các loại đơn trình báo, khiếu nại trực tuyến qua mục [Cổng dân nguyện] trên trang web Bộ Việc làm và Lao động.',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
};
