-- Tesbench
-- ULA

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;

entity ULA_tb is
end ULA_tb;

architecture ULA_tb_arch of ULA_tb is
    component ULA is
        port (
            in1, in2: in  vec32_t;
            control:  in  std_logic_vector(3 downto 0);
            result:   out vec32_t;
            zero:     out std_logic
        );
    end component ULA;

    signal in1, in2: vec32_t;
    signal control:  std_logic_vector(3 downto 0);
    signal result:   vec32_t;
    signal zero:     std_logic;
begin
    ULA0: ULA port map (
        in1     => in1,
        in2     => in2,
        control => control,
        result  => result,
        zero    => zero
    );

    process
        type ULA_control_array is array (natural range <>) of std_logic_vector(3 downto 0);
        type operand_array is array (natural range <>) of vec32_t;

        -- Operacoes geradas aleatoriamente
        constant operations: ULA_control_array := (
            ULA_AND,   ULA_SUBNE, ULA_AND,   ULA_SUB,   ULA_OR,    ULA_SLT,   ULA_AND,   ULA_AND,   ULA_SLT,   ULA_ADD,   ULA_SUB,   ULA_AND,   ULA_SLT,   ULA_SUB,   ULA_AND,
            ULA_ADD,   ULA_SLT,   ULA_AND,   ULA_ADD,   ULA_ADD,   ULA_OR,    ULA_AND,   ULA_SLT,   ULA_SLT,   ULA_SUB,   ULA_ADD,   ULA_ADD,   ULA_SUB,   ULA_SUB,   ULA_SUBNE,
            ULA_SLT,   ULA_ADD,   ULA_SUB,   ULA_ADD,   ULA_OR,    ULA_OR,    ULA_ADD,   ULA_SUB,   ULA_SLT,   ULA_ADD,   ULA_SUB,   ULA_SUB,   ULA_OR,    ULA_AND,   ULA_SLT,
            ULA_AND,   ULA_SUB,   ULA_AND,   ULA_SLT,   ULA_SUBNE, ULA_SUB,   ULA_SUB,   ULA_SUB,   ULA_AND,   ULA_AND,   ULA_OR,    ULA_SUB,   ULA_ADD,   ULA_SLT,   ULA_SUB,
            ULA_AND,   ULA_SLT,   ULA_OR,    ULA_SUBNE, ULA_SUB,   ULA_AND,   ULA_OR,    ULA_ADD,   ULA_SUBNE, ULA_SUBNE, ULA_SLT,   ULA_SUBNE, ULA_OR,    ULA_SLT,   ULA_OR,
            ULA_OR,    ULA_SUB,   ULA_AND,   ULA_AND,   ULA_OR,    ULA_SLT,   ULA_OR,    ULA_SUB,   ULA_SLT,   ULA_SUB,   ULA_SUBNE, ULA_SUBNE, ULA_SUB,   ULA_SUB,   ULA_SUBNE,
            ULA_SUBNE, ULA_OR,    ULA_SLT,   ULA_AND,   ULA_SUB,   ULA_SUBNE, ULA_SLT,   ULA_AND,   ULA_ADD,   ULA_SUBNE, ULA_SUBNE, ULA_SLT,   ULA_AND,   ULA_SUB,   ULA_SUB,
            ULA_AND,   ULA_SUB,   ULA_SUB,   ULA_SLT,   ULA_OR,    ULA_SUB,   ULA_SUB,   ULA_SUBNE, ULA_OR,    ULA_OR,    ULA_SLT,   ULA_SUB,   ULA_ADD,   ULA_SLT,   ULA_SLT,
            ULA_AND,   ULA_SLT,   ULA_SLT,   ULA_OR,    ULA_SUBNE, ULA_OR,    ULA_SUBNE, ULA_ADD,   ULA_OR,    ULA_SUB,   ULA_AND,   ULA_ADD,   ULA_OR,    ULA_OR,    ULA_OR,
            ULA_SLT,   ULA_SUBNE, ULA_AND,   ULA_ADD,   ULA_ADD,   ULA_ADD,   ULA_ADD,   ULA_SLT,   ULA_AND,   ULA_ADD,   ULA_SUBNE, ULA_OR,    ULA_AND,   ULA_ADD,   ULA_AND,
            ULA_SLT,   ULA_OR,    ULA_SUBNE, ULA_AND,   ULA_OR,    ULA_SUB,   ULA_ADD,   ULA_SLT,   ULA_SUB,   ULA_AND,   ULA_AND,   ULA_SLT,   ULA_OR,    ULA_OR,    ULA_SLT,
            ULA_SUBNE, ULA_SUBNE, ULA_SUB,   ULA_OR,    ULA_SUB,   ULA_ADD,   ULA_SUBNE, ULA_SUB,   ULA_OR,    ULA_SUB,   ULA_ADD,   ULA_OR,    ULA_SUB,   ULA_SUB,   ULA_OR,
            ULA_SUBNE, ULA_OR,    ULA_OR,    ULA_ADD,   ULA_OR,    ULA_SUB,   ULA_OR,    ULA_ADD,   ULA_SLT,   ULA_SUB,   ULA_SLT,   ULA_ADD,   ULA_AND,   ULA_SLT,   ULA_SLT,
            ULA_AND,   ULA_SUB,   ULA_SUB,   ULA_SUB,   ULA_ADD,   ULA_SLT,   ULA_AND,   ULA_OR,    ULA_ADD,   ULA_SUB,   ULA_SLT,   ULA_AND,   ULA_ADD,   ULA_SUBNE, ULA_SUBNE,
            ULA_SUBNE, ULA_SUBNE, ULA_SUB,   ULA_ADD,   ULA_SUB,   ULA_SUB,   ULA_SUBNE, ULA_ADD,   ULA_OR,    ULA_AND,   ULA_SUBNE, ULA_AND,   ULA_ADD,   ULA_SUBNE, ULA_SLT,
            ULA_AND,   ULA_OR,    ULA_ADD,   ULA_ADD,   ULA_SLT,   ULA_SLT,   ULA_SLT,   ULA_ADD,   ULA_ADD,   ULA_ADD,   ULA_AND,   ULA_SLT,   ULA_SUB,   ULA_SUBNE, ULA_SUB,
            ULA_ADD,   ULA_SUBNE, ULA_AND,   ULA_AND,   ULA_OR,    ULA_SUBNE, ULA_OR,    ULA_ADD,   ULA_SUBNE, ULA_SLT,   ULA_SUBNE, ULA_ADD,   ULA_SUBNE, ULA_SLT,   ULA_SUBNE
        );

        constant operands1: operand_array := (
            x"42066485", x"A7A775E3", x"0BD29F94", x"18944AFA", x"F1171487", x"B8CEFDD5", x"E082EBE7", x"E678C28B", x"A47EA775", x"B649A660", x"25529167", x"D9AA1135", x"CB6809B5", x"26600B95", x"842FBEA7",
            x"C87CECEA", x"3B48786E", x"2F9ED81F", x"E477925B", x"8AA89E2B", x"24317724", x"26498D5E", x"02A41860", x"83FA1C83", x"3D471281", x"E32720AB", x"9A9DAB49", x"B4A54FD8", x"8914DE85", x"AD1B7140",
            x"ABBA3DA5", x"416A2C8B", x"C80D4786", x"9F269A1F", x"641D6243", x"52FFEF3C", x"05CD5335", x"3BEBE7EB", x"BC6A1C8C", x"684DC3DB", x"FA50F9DF", x"84900502", x"148C0343", x"F4FD37D0", x"D36989D9",
            x"9A5E52F7", x"F43AEECA", x"078B1CF4", x"41F14F76", x"121ECDF6", x"C686FE66", x"C5B17BB3", x"0E143F29", x"16C153D9", x"61D4CF50", x"4AB7D948", x"E7C5C72E", x"14F01FD7", x"608BE3D7", x"F016F6C4",
            x"04C6ED4B", x"3924231F", x"8F649E99", x"A89CFDD0", x"1838B139", x"141616F6", x"DCED7099", x"7B8FAC94", x"562FA6C9", x"9CCC07C8", x"5D69EA5E", x"E537F5DD", x"50F8A108", x"39AC4DA4", x"2781F719",
            x"31B9A54A", x"0F249D19", x"4927F1B6", x"7920FD79", x"87305BAC", x"B14E38A0", x"E809AE0B", x"590AB1F0", x"A523A657", x"833E18B0", x"BF11717A", x"8C032D92", x"4D091A19", x"02933AA9", x"E7BA2290",
            x"82A7E00F", x"CB0EBEC9", x"031B962A", x"4B4F97C8", x"AEFAC51D", x"FC4C3033", x"89443055", x"59F618E9", x"9AE8820E", x"C45298CD", x"E19851E3", x"2D24F309", x"9DFCC311", x"AE99CE9B", x"292271EA",
            x"BDC799A3", x"8CCD12E2", x"0FF37337", x"1CF47E8B", x"E141262B", x"CA3F72BD", x"76E1C1D2", x"51970CF1", x"2FC3B14E", x"62C18053", x"F1A0D152", x"F2FB3FA1", x"B82E2F48", x"2123A658", x"5825A378",
            x"E3A0F241", x"CE7CDC5C", x"FB07BF63", x"45B6333F", x"37F224D0", x"88BC60CC", x"C7DB83C7", x"4C1AF0DF", x"BB24F67E", x"376A5668", x"F20CF353", x"FC31C3F1", x"DB7890B5", x"44E50DD9", x"6A9F4BCC",
            x"E9876EA9", x"F36310EB", x"8FEE1979", x"2F320088", x"82C60ED5", x"4EC80AFB", x"A772AD1A", x"60281001", x"12F6B471", x"BB8713AE", x"6AF24776", x"7009784C", x"8E0D33E9", x"3702A7F5", x"61BFE2BA",
            x"69EBB975", x"E55880F2", x"933EB291", x"DB8681E1", x"221E6826", x"3F6EAFAB", x"28486BC9", x"0F3D57A1", x"A36454F4", x"65F397D4", x"C2082B11", x"CA498728", x"B5CB319D", x"9E2897A5", x"A58C4084",
            x"BABEC5B9", x"8507795D", x"D3DA5165", x"D905C627", x"E85580B0", x"1F757D1D", x"4AA036AB", x"FF894B92", x"E3E89EF2", x"72D29BCD", x"C860FFDC", x"5B251DE7", x"CE8849CE", x"C75DBA5D", x"F7FCE1A3",
            x"8F2D7FFD", x"35D170FB", x"8439370F", x"46F04D61", x"ADB5FF62", x"A9910595", x"E0487E98", x"B767FB36", x"85069F97", x"ED8F5FAC", x"1EF25077", x"BE5AEF4F", x"2514B7BC", x"26B97153", x"6DF0BCAA",
            x"EA46CCB6", x"03913E98", x"9F566074", x"B5799490", x"3E31BA0F", x"875D9513", x"40498D1E", x"3244D4F1", x"6DF34859", x"52A20B71", x"1A1FFECC", x"B61AB57C", x"CB1BDB4C", x"2161B1C0", x"78654200",
            x"70D7E1C0", x"9991A9A8", x"B0DD71E6", x"BA265DF6", x"2D226801", x"2B76919C", x"A81490EC", x"FD1094D2", x"9FA61FD7", x"1DB2B1A1", x"1B4D661C", x"BE59FC09", x"2F9EF8B2", x"07B0DD51", x"41461696",
            x"DC001671", x"4B9C6F01", x"7C724784", x"92A1FB9A", x"266086F7", x"0E025144", x"1B207A3A", x"37B3D6AC", x"C98AF155", x"7D52F707", x"EC8F995E", x"B670AB79", x"CA182FD1", x"D0B55CA6", x"CB38A36B",
            x"D07AAEEC", x"43A9AB42", x"1DF8920D", x"AFE39C21", x"C2F3774A", x"F017A79A", x"917A7A7E", x"1A9BAD3D", x"B617D31B", x"0BD26D8D", x"5ECD59B1", x"1DE27028", x"FC84732F", x"125DCC36", x"3DC7DC21"
        );

        constant operands2: operand_array := (
            x"7B5965DC", x"483B667B", x"DD480EA3", x"D557B8D2", x"A4E34476", x"F46FE403", x"4514B035", x"3836F7BA", x"F7D9C0C7", x"137D3128", x"E17A3847", x"4D2EC130", x"D4B2F7A3", x"7380FB98", x"C98A867F",
            x"B4BEB29C", x"C9C092E5", x"E44295EB", x"3B3E5C6D", x"4DAB8DF3", x"E8EDEFB1", x"4E3B004C", x"65F448D5", x"1EA1CE6D", x"51C3FC32", x"12AA18F8", x"C0349058", x"39A22585", x"9B800C26", x"E10A61B1",
            x"EF5F7756", x"233D3FA9", x"89D82721", x"595D518C", x"710341CF", x"FBC869F3", x"62E78B11", x"63262EDD", x"EB524DF6", x"820485F5", x"62717950", x"05228A4E", x"4DF0A4D9", x"09C2DB4E", x"AF3C89D9",
            x"CE2098CC", x"3E5F48BB", x"3919A693", x"902D19C0", x"3FB5F7CF", x"0042F8F4", x"0F310C45", x"1CE9CD4B", x"60803631", x"42D8FD86", x"8404D1CE", x"B858EBBD", x"81799F5E", x"8CF9F71D", x"11A69480",
            x"4F0AEF22", x"587CE3E0", x"2BFD8494", x"E0CF3380", x"10465B91", x"E7382383", x"FD88A312", x"847B70C7", x"3679DED7", x"D812048D", x"7E676F25", x"D1A21417", x"986BC627", x"C2F2BA7E", x"392CC770",
            x"7157DD67", x"ECC71F5E", x"C425F432", x"44CBB4BF", x"44E0B75F", x"F30EF630", x"C17D59B9", x"F5799BC4", x"279E23AB", x"ED25DEA1", x"C6682F96", x"369C69F1", x"BAA8B7EE", x"71858494", x"24747D07",
            x"F5734B69", x"CF31C41D", x"F6FA7316", x"DEDB871F", x"6D515487", x"9CD28415", x"EB026BB7", x"F510D93D", x"36B725C5", x"34502E85", x"5D17EA5E", x"6749ECB8", x"61CF7AF5", x"CF9D9F99", x"7EAC808A",
            x"9F6BCC5B", x"149D2F86", x"925AD981", x"1E8476D1", x"F50C2699", x"8E2C0FE5", x"3A41E39B", x"F9D4921C", x"B42DB035", x"B3FB60A6", x"09C9CFBD", x"C0A8ED99", x"0C06E9D2", x"6C26601B", x"4A211CE1",
            x"6F6E45A1", x"ACF8E5DC", x"D78FE67E", x"21BBD221", x"0F3F1852", x"6251459F", x"F33FF60D", x"D62D1EAD", x"D3FBEF0F", x"2ACD38C8", x"401D883F", x"D123C5EC", x"12867BC8", x"39958468", x"13F6647A",
            x"1CD3B1ED", x"BDC68914", x"E07EC899", x"20CBAAD9", x"F11FD263", x"EC834624", x"A31C2238", x"2059C434", x"5DC699A1", x"CB9EA614", x"33C67D13", x"0EF33217", x"C6CAAC76", x"68185BE5", x"70B9BCDF",
            x"3836915E", x"38CE9B94", x"1AFBABED", x"1147BB77", x"820957B6", x"278A3408", x"6219064B", x"366D02D4", x"236C39E9", x"14624EB5", x"E713A85B", x"4813D52D", x"5D4BC81B", x"6F65692E", x"BDFA3139",
            x"136C2757", x"E732739E", x"609065D5", x"4A28A6F3", x"BAF83C49", x"E7E68228", x"FF35209D", x"BF3CE08E", x"DE020CF5", x"29CDCA2E", x"B31FCD6F", x"11B0698A", x"4712C146", x"57274EB7", x"57723BE3",
            x"A3421DAD", x"5EFF9BFE", x"598DD7E6", x"21D64AB4", x"82EEF4BE", x"F45027C7", x"54973AEA", x"8DD6FDB2", x"9178821B", x"8901AE67", x"00B1012C", x"701E779D", x"0F69AFE4", x"81563950", x"17F05D96",
            x"B235A034", x"35905D45", x"F57B2ECC", x"FF80C5AC", x"16B585A6", x"4AF70B5A", x"8E78BF11", x"FA004507", x"0B80002E", x"9CD823C7", x"892A7562", x"37E637A9", x"D2BAE30F", x"9C211E14", x"6B9FAD43",
            x"716683A6", x"DBF3B3AC", x"9DC8CA10", x"E8C0CC8C", x"D191D41E", x"33E404E4", x"52573CE3", x"BDE20354", x"D9E6CE05", x"D4FE133D", x"CACCD127", x"B42CE672", x"234ED825", x"C5C3C532", x"586F887B",
            x"0CF260C4", x"7720F336", x"9611B1BC", x"DE6D42C6", x"9EFFB0F0", x"E1EF6633", x"968986A3", x"A2D72E9A", x"BA1A8848", x"E079131E", x"ACDC3561", x"723A5753", x"D7136F23", x"09FE5B69", x"90876822",
            x"3CB1C60D", x"F99980C5", x"7E3CB040", x"9801D41B", x"DCE87B85", x"848DED43", x"FDE32314", x"849EFF89", x"084E13A2", x"09DE6F1A", x"3095E6E7", x"65311D42", x"7C9DA543", x"A8AAD00B", x"35B3B8D2"
        );

        constant results: operand_array := (
            x"42006484", x"5F6C0F68", x"09400E80", x"433C9228", x"F5F754F7", x"00000001", x"4000A025", x"2030C28A", x"00000001", x"C9C6D788", x"43D85920", x"492A0130", x"00000001", x"B2DF0FFD", x"800A8627",
            x"7D3B9F86", x"00000001", x"2402900B", x"1FB5EEC8", x"D8542C1E", x"ECFDFFB5", x"0609004C", x"00000001", x"00000000", x"EB83164F", x"F5D139A3", x"5AD23BA1", x"7B032A53", x"ED94D25F", x"CC110F8F",
            x"00000001", x"64A76C34", x"3E352065", x"F883EBAB", x"751F63CF", x"FBFFEFFF", x"68B4DE46", x"D8C5B90E", x"00000001", x"EA5249D0", x"97DF808F", x"7F6D7AB4", x"5DFCA7DB", x"00C01340", x"00000000",
            x"8A0010C4", x"B5DBA60F", x"01090490", x"00000001", x"D268D627", x"C6440572", x"B6806F6E", x"F12A71DE", x"00801211", x"40D0CD00", x"CEB7D9CE", x"2F6CDB71", x"9669BF35", x"00000001", x"DE706244",
            x"0402ED02", x"00000001", x"AFFD9E9D", x"C7CDCA50", x"07F255A8", x"04100282", x"FDEDF39B", x"000B1D5B", x"1FB5C7F2", x"C4BA033B", x"00000001", x"1395E1C6", x"D8FBE72F", x"00000001", x"3FADF779",
            x"71FFFD6F", x"225D7DBB", x"4025F032", x"4000B439", x"C7F0FFFF", x"00000001", x"E97DFFBB", x"6391162C", x"00000000", x"96183A0F", x"F8A941E4", x"5566C3A1", x"9260622B", x"910DB615", x"C345A589",
            x"8D3494A6", x"CF3FFEDD", x"00000001", x"4A4B8708", x"41A97096", x"5F79AC1E", x"00000001", x"51101829", x"D19FA7D3", x"90026A48", x"84806785", x"00000001", x"01CC4211", x"DEFC2F02", x"AA75F160",
            x"9D438803", x"782FE35C", x"7D9899B6", x"00000001", x"F54D26BB", x"3C1362D8", x"3C9FDE37", x"57C27AD5", x"BFEFB17F", x"F3FBE0F7", x"00000000", x"32525208", x"C435191A", x"00000001", x"00000000",
            x"63204001", x"00000000", x"00000000", x"65BFF33F", x"28B30C7E", x"EAFD65DF", x"D49B8DBA", x"22480F8C", x"FBFFFF7F", x"0C9D1DA0", x"400C8013", x"CD5589DD", x"DBFEFBFD", x"7DF58DF9", x"7BFF6FFE",
            x"00000000", x"359C87D7", x"806E0819", x"4FFDAB61", x"73E5E138", x"3B4B511F", x"4A8ECF52", x"00000000", x"10C69021", x"8725B9C2", x"372BCA63", x"7EFB7A5F", x"86082060", x"9F1B03DA", x"60B9A09A",
            x"00000000", x"FDDE9BF6", x"784306A4", x"11068161", x"A21F7FB6", x"17E47BA3", x"8A617214", x"00000001", x"7FF81B0B", x"04620694", x"C2002811", x"00000000", x"FDCBF99F", x"FF6DFFAF", x"00000001",
            x"A7529E62", x"9DD505BF", x"7349EB90", x"DB2DE6F7", x"2D5D4467", x"075BFF45", x"4B6B160E", x"404C6B04", x"FFEA9EF7", x"4904D19F", x"7B80CD4B", x"5BB57DEF", x"87758888", x"70366BA6", x"F7FEFBE3",
            x"EBEB6250", x"7FFFFBFF", x"DDBDF7EF", x"68C69815", x"AFFFFFFE", x"B540DDCE", x"F4DF7EFA", x"453EF8E8", x"00000001", x"648DB145", x"00000000", x"2E7966EC", x"0500A7A4", x"00000001", x"00000000",
            x"A2048034", x"CE00E153", x"A9DB31A8", x"B5F8CEE4", x"54E73FB5", x"00000000", x"00488D10", x"FA44D5F7", x"79734887", x"B5C9E7AA", x"00000001", x"36023528", x"9DD6BE5B", x"854093AC", x"0CC594BD",
            x"FF715E1A", x"BD9DF5FC", x"1314A7D6", x"A2E72A82", x"5B9093E3", x"F7928CB8", x"55BD5409", x"BAF29826", x"DFE6DFD7", x"14B21121", x"508094F5", x"B408E400", x"52EDD0D7", x"41ED181F", x"00000001",
            x"0C000040", x"7FBCFF37", x"1283F940", x"710F3E60", x"00000001", x"00000001", x"00000001", x"DA8B0546", x"83A5799D", x"5DCC0A25", x"AC8C1140", x"00000000", x"F304C0AE", x"C6B7013D", x"3AB13B49",
            x"0D2C74F9", x"4A102A7D", x"1C389000", x"88019401", x"DEFB7FCF", x"6B89BA57", x"FDFB7B7E", x"9F3AACC6", x"ADC9BF79", x"00000000", x"2E3772CA", x"83138D6A", x"7FE6CDEC", x"00000001", x"0814234F"
        );


    begin
        for op in operands1'range loop
            control <= operations(op);
            in1 <= operands1(op);
            in2 <= operands2(op);
            wait for 5 ns;

            assert result = results(op)
                report "Error!"
                severity error;
        end loop;

        assert false report "End of ULA testbench" severity note;
        wait;
    end process;
end ULA_tb_arch;