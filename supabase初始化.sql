-- ============================================================
-- KRN科瑞诺参数筛选器 - Supabase 数据库初始化脚本
-- 使用方法：登录 Supabase → 左侧 SQL Editor → 新建查询 → 粘贴全部 → Run
-- ============================================================

-- 1. 创建分类配置表
CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  sort_order INT DEFAULT 0,
  config JSONB NOT NULL DEFAULT '{}'
);

-- 2. 创建产品表
CREATE TABLE IF NOT EXISTS products (
  id BIGSERIAL PRIMARY KEY,
  category TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  model TEXT NOT NULL,
  manufacturer TEXT DEFAULT '',
  spec_data JSONB DEFAULT '{}',
  price TEXT DEFAULT '',
  datasheet_url TEXT DEFAULT '',
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_model ON products(model);

-- 3. 启用行级安全(RLS)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- 4. RLS策略：允许公开读取
CREATE POLICY "Public read categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Public read products" ON products FOR SELECT USING (true);

-- 5. RLS策略：允许公开写入（后台管理页面需要）
CREATE POLICY "Public write categories" ON categories FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Public write products" ON products FOR ALL USING (true) WITH CHECK (true);

-- 6. 插入7个分类配置
INSERT INTO categories (id, name, sort_order, config) VALUES
('esd', 'ESD静电保护管', 1, '{"filters":[{"key":"kind","name":"种类","options":["普容ESD静电防护","低电容ESD静电防护","高分子ESD"]},{"key":"package","name":"Package","options":["SLP0402P2(01005)","DFN0603-2(0201)","DFN1006-2(0402)","SOD-323","SOD-523"]},{"key":"vrwm","name":"VRWM(V)","options":["1.0V","1.5V","2.5V","3.3V","5.0V","6.0V"]},{"key":"channel","name":"Channel","options":["1-Line","2-Line","4-Line"]},{"key":"cj","name":"Cj(PF)","options":["0.08","0.12","0.15","0.5","1.0","3.0"]},{"key":"ipp","name":"IPP(A)","options":["2.0","2.5","3.0","5.0","8.0"]}]}'),
('mos', '场效应管（MOS管）', 2, '{"filters":[{"key":"kind","name":"种类","options":["NMOS","PMOS","N+P MOS"]},{"key":"package","name":"Package","options":["SOT-23","SOT-323","SOT-523","SOT-89","DFN2x2"]},{"key":"withESD","name":"With ESD","options":["Yes","No"]},{"key":"vds","name":"Vds(V)","options":["20","30","40","60","100"]},{"key":"vgs","name":"Vgs(±V)","options":["8","12","20"]},{"key":"id","name":"Id(A)","options":["1","2","3","5","8","12"]},{"key":"vgsth","name":"VGS(th)V Typ","options":["0.8","1.0","1.5","2.0"]},{"key":"rdson","name":"Rds(on) 10V","options":["10","20","30","50","80","120"]}]}'),
('power', '电源管理', 3, '{"filters":[{"key":"kind","name":"种类","options":["LDO","DC-DC降压","DC-DC升压","LED驱动","电池充电"]},{"key":"package","name":"Package","options":["SOT-23-5","SOT-23-6","SOT-89","SOP-8","MSOP-8","QFN-16"]},{"key":"inputVoltage","name":"输入耐压(V)","options":["6","8","12","24","28","36","40"]},{"key":"workCurrent","name":"工作电流(Max)","options":["0.5A","1A","2A","3A","5A"]},{"key":"outputVoltage","name":"输出电压(V)","options":["1.2","1.8","3.3","5","12","可调"]},{"key":"quiescentCurrent","name":"静态功耗(μA)","options":["1","5","10","50","100"]},{"key":"rippleRejection","name":"纹波抑制比（1K Hz）","options":["60dB","70dB","80dB","90dB"]}]}'),
('gdt', '气体放电管', 4, '{"filters":[{"key":"kind","name":"种类","options":["贴片GDT","插件GDT"]},{"key":"package","name":"Package","options":["SMD4532","SMD3220","DIP5.5","DIP7.0"]},{"key":"vsMax","name":"Vs(max)","options":["500","600","700","800"]},{"key":"is","name":"Is","options":["100A","200A","300A","500A"]},{"key":"idAtVdMax","name":"Id@Vd(max)","options":["1A","2A","3A","5A"]},{"key":"vd","name":"Vd","options":["75","90","150","230","350","470"]},{"key":"coTyp","name":"Co*(typ)","options":["≤1","≤2","≤5"]},{"key":"ihMin","name":"Ih(min)","options":["50mA","100mA","150mA"]}]}'),
('tvs', '瞬态抑制二极管', 5, '{"filters":[{"key":"kind","name":"种类","options":["单向TVS","双向TVS","低电容TVS","ESD保护TVS"]},{"key":"package","name":"Package","options":["SMA","SMB","SMC","SOD-323","SOD-523","DFN"]},{"key":"unibi","name":"UNI/BI","options":["UNI","BI"]},{"key":"vrwm","name":"Vrwm(V)","options":["5","6","12","15","24","36"]},{"key":"pppm","name":"PPPM(W)","options":["400","600","1000","1500","3000","5000"]},{"key":"vbrMin","name":"Vbr(V)min","options":["6","7","13","17","26","40"]},{"key":"vbrMax","name":"Vbr(V)Max","options":["7","8","15","19","29","43"]},{"key":"ir","name":"Ir(uA)","options":["1","5","10","100"]}]}'),
('bjt', '通用二三极管', 6, '{"filters":[{"key":"kind","name":"种类","options":["NPN三极管","PNP三极管","肖特基二极管","开关二极管","快恢复二极管"]},{"key":"package","name":"Package","options":["SOT-23","SOT-323","SOD-123","SOD-323","SOD-523","SMA"]},{"key":"vr","name":"VR(V)","options":["20","40","45","60","80","100"]},{"key":"if","name":"If(A)","options":["0.1","0.15","0.2","0.5","1","1.5","3"]},{"key":"vf","name":"VF(V)","options":["0.3","0.4","0.5","0.6","0.7"]},{"key":"ifsm","name":"Ifsm(A)","options":["1","3","5","10","30"]},{"key":"irMax","name":"IR(uA)max.","options":["0.5","1","5","10","100"]}]}'),
('opamp', '运算放大器及比较器', 7, '{"filters":[{"key":"kind","name":"种类","options":["运算放大器","比较器"]},{"key":"package","name":"Package","options":["SOT-23-5","SOT-23-8","SOP-8","MSOP-8","SOP-14","QFN"]},{"key":"powerSupply","name":"Power supply","options":["1.8V~5.5V","2.7V~5.5V","3V~36V","±2.5V~±18V"]},{"key":"rail","name":"Rail to Rail","options":["Yes","No"]},{"key":"gbw","name":"GBW","options":["1","10","50","100","200"]},{"key":"iq","name":"IQ","options":["100","200","500","1000"]},{"key":"inputBiasCurrent","name":"Input Bias Current","options":["1pA","10pA","100pA","1nA"]}]}')
ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name, config=EXCLUDED.config, sort_order=EXCLUDED.sort_order;

-- 7. 插入示例产品数据

-- ESD静电保护管
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('esd', 'ESD9B3.3T5G', 'ON Semiconductor', '{"kind":"低电容ESD静电防护","package":"SOD-523","vrwm":"3.3V","channel":"1-Line","cj":"0.5","ipp":"2.0"}', '0.038', '', 1),
('esd', 'ESD9B5.0T5G', 'ON Semiconductor', '{"kind":"低电容ESD静电防护","package":"SOD-523","vrwm":"5.0V","channel":"1-Line","cj":"0.5","ipp":"2.5"}', '0.040', '', 2),
('esd', 'PESD5V0S2BT', 'NXP', '{"kind":"普容ESD静电防护","package":"SOD-323","vrwm":"5.0V","channel":"1-Line","cj":"3.0","ipp":"5.0"}', '0.035', '', 3),
('esd', 'PESD3V3S2BT', 'NXP', '{"kind":"普容ESD静电防护","package":"SOD-323","vrwm":"3.3V","channel":"1-Line","cj":"3.0","ipp":"5.0"}', '0.033', '', 4),
('esd', 'ESD7104XBJ', 'Littelfuse', '{"kind":"低电容ESD静电防护","package":"DFN1006-2(0402)","vrwm":"5.0V","channel":"4-Line","cj":"0.15","ipp":"2.5"}', '0.065', '', 5),
('esd', 'ESD0524BMX', 'Littelfuse', '{"kind":"低电容ESD静电防护","package":"DFN1006-2(0402)","vrwm":"5.0V","channel":"4-Line","cj":"0.12","ipp":"2.0"}', '0.058', '', 6);

-- 场效应管（MOS管）
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('mos', 'AO3400A', 'AOS', '{"kind":"NMOS","package":"SOT-23","withESD":"No","vds":"30","vgs":"20","id":"5","vgsth":"1.0","rdson":"30"}', '0.032', '', 1),
('mos', 'AO3401A', 'AOS', '{"kind":"PMOS","package":"SOT-23","withESD":"No","vds":"30","vgs":"20","id":"4","vgsth":"1.5","rdson":"50"}', '0.035', '', 2),
('mos', 'SI2302', 'Silergy', '{"kind":"NMOS","package":"SOT-23","withESD":"No","vds":"20","vgs":"8","id":"2","vgsth":"1.0","rdson":"80"}', '0.028', '', 3),
('mos', 'SI2301', 'Silergy', '{"kind":"PMOS","package":"SOT-23","withESD":"No","vds":"20","vgs":"8","id":"2","vgsth":"1.5","rdson":"120"}', '0.030', '', 4),
('mos', 'AO4407A', 'AOS', '{"kind":"PMOS","package":"SOT-89","withESD":"No","vds":"30","vgs":"20","id":"12","vgsth":"1.5","rdson":"10"}', '0.085', '', 5),
('mos', 'AO6602', 'AOS', '{"kind":"N+P MOS","package":"SOT-23","withESD":"Yes","vds":"20","vgs":"8","id":"3","vgsth":"1.0","rdson":"50"}', '0.040', '', 6);

-- 电源管理
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('power', 'AMS1117-3.3', 'AMS', '{"kind":"LDO","package":"SOT-223","inputVoltage":"12","workCurrent":"1A","outputVoltage":"3.3","quiescentCurrent":"100","rippleRejection":"70dB"}', '0.045', '', 1),
('power', 'ME6211C33', 'Microne', '{"kind":"LDO","package":"SOT-23-5","inputVoltage":"6","workCurrent":"0.5A","outputVoltage":"3.3","quiescentCurrent":"1","rippleRejection":"70dB"}', '0.038', '', 2),
('power', 'MP1584EN', 'MPS', '{"kind":"DC-DC降压","package":"SOP-8","inputVoltage":"28","workCurrent":"3A","outputVoltage":"可调","quiescentCurrent":"100","rippleRejection":"60dB"}', '0.120', '', 3),
('power', 'MP2315', 'MPS', '{"kind":"DC-DC降压","package":"QFN-16","inputVoltage":"24","workCurrent":"5A","outputVoltage":"可调","quiescentCurrent":"50","rippleRejection":"70dB"}', '0.180', '', 4),
('power', 'MT3608', 'Aerosemi', '{"kind":"DC-DC升压","package":"SOT-23-6","inputVoltage":"24","workCurrent":"2A","outputVoltage":"可调","quiescentCurrent":"100","rippleRejection":"60dB"}', '0.055', '', 5),
('power', 'TP4056', 'NanJing TopPower', '{"kind":"电池充电","package":"SOP-8","inputVoltage":"8","workCurrent":"1A","outputVoltage":"4.2","quiescentCurrent":"10","rippleRejection":"70dB"}', '0.085', '', 6);

-- 气体放电管
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('gdt', 'GDT-90V-SMD', 'Bourns', '{"kind":"贴片GDT","package":"SMD3220","vsMax":"600","is":"100A","idAtVdMax":"1A","vd":"90","coTyp":"≤1","ihMin":"100mA"}', '0.090', '', 1),
('gdt', 'GDT-150V-SMD', 'Bourns', '{"kind":"贴片GDT","package":"SMD3220","vsMax":"600","is":"200A","idAtVdMax":"2A","vd":"150","coTyp":"≤1","ihMin":"100mA"}', '0.095', '', 2),
('gdt', 'GDT-230V-SMD', 'EPCOS', '{"kind":"贴片GDT","package":"SMD4532","vsMax":"700","is":"300A","idAtVdMax":"3A","vd":"230","coTyp":"≤2","ihMin":"150mA"}', '0.110', '', 3),
('gdt', 'GDT-350V-SMD', 'EPCOS', '{"kind":"贴片GDT","package":"SMD4532","vsMax":"800","is":"500A","idAtVdMax":"5A","vd":"350","coTyp":"≤2","ihMin":"150mA"}', '0.120', '', 4),
('gdt', 'GDT-75V-DIP', 'Brightking', '{"kind":"插件GDT","package":"DIP5.5","vsMax":"500","is":"100A","idAtVdMax":"1A","vd":"75","coTyp":"≤5","ihMin":"100mA"}', '0.080', '', 5),
('gdt', 'GDT-470V-DIP', 'Brightking', '{"kind":"插件GDT","package":"DIP7.0","vsMax":"800","is":"500A","idAtVdMax":"5A","vd":"470","coTyp":"≤2","ihMin":"150mA"}', '0.135', '', 6);

-- 瞬态抑制二极管（TVS）
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('tvs', 'SMAJ5.0A', 'Littelfuse', '{"kind":"单向TVS","package":"SMA","unibi":"UNI","vrwm":"5","pppm":"400","vbrMin":"6","vbrMax":"7","ir":"100"}', '0.038', '', 1),
('tvs', 'SMAJ5.0CA', 'Littelfuse', '{"kind":"双向TVS","package":"SMA","unibi":"BI","vrwm":"5","pppm":"400","vbrMin":"6","vbrMax":"7","ir":"100"}', '0.042', '', 2),
('tvs', 'SMAJ12CA', 'ST', '{"kind":"双向TVS","package":"SMA","unibi":"BI","vrwm":"12","pppm":"400","vbrMin":"13","vbrMax":"15","ir":"5"}', '0.045', '', 3),
('tvs', 'SMBJ24CA', 'ST', '{"kind":"双向TVS","package":"SMB","unibi":"BI","vrwm":"24","pppm":"600","vbrMin":"26","vbrMax":"29","ir":"5"}', '0.072', '', 4),
('tvs', 'SMCJ36CA', 'ON Semiconductor', '{"kind":"双向TVS","package":"SMC","unibi":"BI","vrwm":"36","pppm":"1500","vbrMin":"40","vbrMax":"43","ir":"10"}', '0.130', '', 5),
('tvs', 'PESD5V0S1BA', 'NXP', '{"kind":"ESD保护TVS","package":"SOD-323","unibi":"BI","vrwm":"5","pppm":"1000","vbrMin":"6","vbrMax":"7","ir":"1"}', '0.028', '', 6);

-- 通用二三极管
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('bjt', 'S8050', 'UTC', '{"kind":"NPN三极管","package":"SOT-23","vr":"20","if":"0.5","vf":"0.7","ifsm":"10","irMax":"10"}', '0.015', '', 1),
('bjt', 'S8550', 'UTC', '{"kind":"PNP三极管","package":"SOT-23","vr":"20","if":"0.5","vf":"0.7","ifsm":"10","irMax":"10"}', '0.015', '', 2),
('bjt', '2N3904', 'ON Semiconductor', '{"kind":"NPN三极管","package":"SOT-23","vr":"40","if":"0.2","vf":"0.7","ifsm":"3","irMax":"1"}', '0.012', '', 3),
('bjt', 'BAT54', 'NXP', '{"kind":"肖特基二极管","package":"SOT-23","vr":"40","if":"0.2","vf":"0.3","ifsm":"1","irMax":"10"}', '0.018', '', 4),
('bjt', '1N4148W', 'Vishay', '{"kind":"开关二极管","package":"SOD-123","vr":"80","if":"0.15","vf":"0.6","ifsm":"5","irMax":"5"}', '0.010', '', 5),
('bjt', 'SS14', 'MCC', '{"kind":"肖特基二极管","package":"SMA","vr":"40","if":"1","vf":"0.4","ifsm":"30","irMax":"100"}', '0.025', '', 6);

-- 运算放大器及比较器
INSERT INTO products (category, model, manufacturer, spec_data, price, datasheet_url, sort_order) VALUES
('opamp', 'LM358DR', 'TI', '{"kind":"运算放大器","package":"SOP-8","powerSupply":"3V~36V","rail":"No","gbw":"1","iq":"1000","inputBiasCurrent":"100pA"}', '0.045', '', 1),
('opamp', 'LM324DR', 'TI', '{"kind":"运算放大器","package":"SOP-14","powerSupply":"3V~36V","rail":"No","gbw":"1","iq":"1000","inputBiasCurrent":"100pA"}', '0.058', '', 2),
('opamp', 'LMV358IDR', 'TI', '{"kind":"运算放大器","package":"SOP-8","powerSupply":"2.7V~5.5V","rail":"Yes","gbw":"1","iq":"200","inputBiasCurrent":"10pA"}', '0.065', '', 3),
('opamp', 'TLV9002IDR', 'TI', '{"kind":"运算放大器","package":"SOP-8","powerSupply":"1.8V~5.5V","rail":"Yes","gbw":"1","iq":"100","inputBiasCurrent":"1pA"}', '0.078', '', 4),
('opamp', 'OPA2333AIDR', 'TI', '{"kind":"运算放大器","package":"SOP-8","powerSupply":"1.8V~5.5V","rail":"Yes","gbw":"10","iq":"200","inputBiasCurrent":"1pA"}', '0.150', '', 5),
('opamp', 'LM393DR', 'TI', '{"kind":"比较器","package":"SOP-8","powerSupply":"3V~36V","rail":"No","gbw":"1","iq":"1000","inputBiasCurrent":"100pA"}', '0.052', '', 6),
('opamp', 'TLV3201AIDBVR', 'TI', '{"kind":"比较器","package":"SOT-23-5","powerSupply":"2.7V~5.5V","rail":"Yes","gbw":"200","iq":"100","inputBiasCurrent":"1pA"}', '0.120', '', 7);

-- 完成
SELECT '数据库初始化完成！共插入 7 个分类，43 条产品数据。' AS result;
