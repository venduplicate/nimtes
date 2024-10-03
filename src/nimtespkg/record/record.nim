import std/[options, json, streams,strformat,strutils]
import enums, util, constants
from std/unicode import split

type
    RGBA* = object
        r*: uint8
        g*: uint8
        b*: uint8
        a*: uint8
    RGB* = object
        r*:uint8
        g*:uint8
        b*:uint8
    Grid2D[T: int8|int16|int32|int64] = object
        x,y:T
    Grid3D[T: int8|int16|int32|int64] = object 
        x,y,z:T
    AlchemyData = object
        weight*: float32
        value*: uint32
        flags*: uint32
    Enchantment = object
        effectIdx*: uint16
        skill*: int8
        attribute*: int8
        effectRange*: uint32
        area*: uint32
        duration*: uint32
        magnitudeMin*: uint32
        magnitudeMax*: uint32
    AlchemyApparatusData = object
        kind*: uint32
        quality*: float32
        weight*: float32
        value*: uint32
    ArmorData* = object
        kind*: uint32
        weight*: float32
        value*: uint32
        health*: uint32
        enchantPoints*: uint32
        armorRating*: uint32
    BipedObject = object
        kind*: uint32
        bnam*: Option[string] = none(string)
        cnam*: Option[string] = none(string)
    BodyPartData = object
        part*: BodyPart
        vampire*: uint8
        flags*: seq[BodyFlags]
        partKind*: BodyPartKind
    BookData = object
        weight*: float32
        value*: uint32
        flags*: uint32
        skillId*: int32
        enchantPoints*: uint32
    Coords3D = object
        posX*: float32
        posY*: float32
        posZ*: float32
        rotX*: float32
        rotY*: float32
        rotZ*: float32
    CellTravel = object
        destination*: Coords3D
        previous_cell*: Option[string] = none(string)
    FormRef = object
        frmr*: uint32
        name*: string
        unam*: Option[uint8] = none(uint8)
        xscl*: Option[float32] = none(float32)
        anam*: Option[string] = none(string)
        bnam*: Option[string] = none(string)
        cnam*: Option[string] = none(string)
        indx*: Option[uint32] = none(uint32)
        xsol*: Option[string] = none(string)
        xchg*: Option[float32] = none(float32)
        intv*: Option[float32] = none(float32)
        nam9*: Option[uint32] = none(uint32)
        cellTravel*: seq[CellTravel] = @[]
        fltv*: Option[float32] = none(float32)
        knam*: Option[string] = none(string)
        tnam*: Option[string] = none(string)
        znam*: Option[uint8] = none(uint8)
        data*: Option[Coords3D] = none(Coords3D)
    MovedRef = object
        mvrf*: uint32
        cnam*: Option[string] = none(string)
        cndt*: Option[Grid2D[int32]] = none(Grid2D[int32])
        frmr*: Option[FormRef] = none(FormRef)
    CellData = object
        flags*: seq[CellDataFlags]
        gridX*: int32
        gridY*: int32
    AmbientLight = object
        ambientColor*: RGBA
        sunlightColor*: RGBA
        fogColor*: RGBA
        fogDensity*: float32
    AttributeDuo = object 
        one*: uint32
        two*: uint32
    ClassData = object
        attribute*: AttributeDuo
        specialization*: uint32
        minorSkills*: seq[uint32] = @[]
        majorSkills*: seq[uint32] = @[]
        flags*: seq[ClassAutoCalcFlags]
        autoCalc*: uint32
    ClothingData = object
        kind*: uint32
        weight*: float32
        value*: uint16
        enchantment_points*: uint16
    CreatureData = object
        kind*: CreatureKind
        level*: uint32
        attributes*: array[0..7, uint32]
        health*: uint32
        spellPts*: uint32
        fatigue*: uint32
        soul*: uint32
        combat*: uint32
        magic*: uint32
        stealth*: uint32
        attackMin1*: uint32
        attackMax1*: uint32
        attackMin2*: uint32
        attackMax2*: uint32
        attackMin3*: uint32
        attackMax3*: uint32
        gold*: uint32
    AIData = object
        hello*: uint8
        unknown*: uint8
        fight*: uint8
        flee*: uint8
        alarm*: uint8
        flags*: seq[AIDataFlags]
    AIPackage = object
        case kind*: AIPackageKind
            of AIActivate:
                aianame*: string
            of AIEscort:
                aiex*: float32
                aiey*: float32
                aiez*: float32
                aieduration*: uint16
                aieid*: string
                aiecndt*: Option[string] = none(string)
            of AIFollow:
                aifx*: float32
                aify*: float32
                aifz*: float32
                aifduration*: uint16
                aifid*: string
                aifcndt*: Option[string] = none(string)
            of AITravel:
                aitx*: float32
                aity*: float32
                aitz*: float32
            of AIWander:
                aiwdistance*: uint16
                aiwduration*: uint16
                aiwtimeofday*: uint8
                aiwidles*: array[0..7, uint8]
    EnchantmentData = object
        kind*: uint32
        cost*: uint32
        charge*: uint32
        flags*: EnchantmentKind
    RankData = object
        attributes*: AttributeDuo
        primarySkill*: uint32
        favoredSkill*: uint32
        factionReaction*: uint32
    FactionData = object
        attributes*: AttributeDuo
        rankData*: array[0..9,RankData]
        skills*: array[0..6, int32]
        flags*: uint32
    InfoData = object
        kind*: uint8
        disposition*: uint32
        rank*: int8
        gender*: int8
        pcrank*: int8
    FilterData = object
        index*: char
        kind*: FilterFunctionKind
        details*: string
        op*: char
        name*: string
        comparison_int*: Option[uint32] = none(uint32)
        comparison_float*: Option[float32] = none(float32)
    IngredientData = object
        weight*: float32
        value*: uint32
        effects*: array[0..3, int32]
        skills*: array[0..3, int32]
        attributes: array[0..3, int32]
    HeightData = object
        offset*: float32
        data*: array[0..64, array[0..64, int8]]
    LightData = object
        weight*: float32
        value*: uint32
        time*: int32
        radius*: uint32
        color*: RGBA
        flags*: seq[LightFlags]
    LockData = object
        weight*: float32
        value*: uint32
        quality*: float32
        uses*: uint32
    MagicEffectData = object
        school*: uint32
        baseCost*: float32
        flags*: seq[MagicEffectFlags]
        red*: uint32
        green*: uint32
        blue*: uint32
        speedX*: float32
        sizeX*: float32
        sizeCap*: float32
    MiscWeaponData = object
        weight*: float32
        value*: uint32
    AttributeArray = array[0..7, uint8]
    SkillArray = array[0..26, uint8]
    NPCData = object
        level*: uint16
        attributes*: Option[AttributeArray] = none(AttributeArray)
        skills*: Option[SkillArray] = none(SkillArray)
        health*: Option[uint16] = none(uint16)
        spell_points*: Option[uint16] = none(uint16)
        fatigue*: Option[uint16] = none(uint16)
        disposition*: uint8
        reputation*: uint8
        rank*: uint8
        gold*: uint32
    PathGridData = object
        gridX*: int32
        gridY*: int32
        flags*: seq[PathGridFlags]
        point_count*: uint16
    PathPoint = object
        location: Grid3D[int32]
        flags*: uint8
        connectionCount*: uint8
    ProbeData = object
        weight*: float32
        value*: uint32
        quality*: float32
        uses*: uint32
    Gender = object
        male*: uint32
        female*: uint32
    SkillBonus = object 
        id*: int32
        bonus*: int32
    RaceData = object
        skillbonuses*: array[0..6, SkillBonus]
        attributes*: array[0..7, AttributeDuo]
        height*: Gender
        weight*: Gender
        flags*: seq[RaceFlags]
    RepairData = object
        weight*: float32
        value*: uint32
        quality*: float32
        uses*: uint32
    ScriptHeader = object
        name*: string
        num_shorts*: uint32
        num_longs*: uint32
        num_floats*: uint32
        script_data_size*: uint32
        local_var_size*: uint32
    SkillData = object
        attribute*: uint32
        specialization*: uint32
        useValues*: array[0..3, float32]
    SpellData = object
        kind*: SpellKind
        spellCost*: uint32
        flags*: seq[SpellFlags]
    HeaderData = object
        version*: float32
        flags*: uint32
        author*: string
        fileDesc*: string
        numRecords*: uint32
    MasterFile = object
         mast*: string
         data*: uint64
    MinMax = object
        min*: uint8
        max*: uint8
    WeaponData = object
        weight*: float32
        value*: uint32
        kind*: WeaponKind
        health*: uint16
        speed*: float32
        reach*: float32
        enchantPoints*: uint16
        chop*: MinMax
        slash*: MinMax
        thrust*: MinMax
        flags*: seq[WeaponKind]
    #CellTravel = tuple[destination:Coords3D,previous_cell:Option[string] = none(string)]
    TES3Record = object of RootObj
        kind*: TES3Kind
        size*: uint32
        flags*: RecordFlags
        dele*: bool = false
        id*: string
        model_name*: Option[string] = none(string)
        full_name*:Option[string] = none(string)
        script_name*: Option[string] = none(string)
    ActivatorRecord = ref object of TES3Record
    PotionRecord = ref object of TES3Record
        icon_name*: Option[string] = none(string)
        data*: AlchemyData
        enchantments*: seq[Enchantment] = @[]
    AlchemyApparatusRecord = ref object of TES3Record
        data*: Option[AlchemyApparatusData] = none(AlchemyApparatusData)
        icon_name*: Option[string]
    ArmorRecord = ref object of TES3Record
        data*: ArmorData
        icon_name*: Option[string] = none(string)
        biped_objects*: seq[BipedObject] = @[]
        enchantment_name*: Option[string] = none(string)
    BodyRecord = ref object of TES3Record
        data*: BodyPartData
    BookRecord = ref object of TES3Record
        data*: BookData
        icon_name*: Option[string] = none(string)
        text*: Option[string] = none(string)
        enchantment_name*: Option[string] = none(string)
    BirthSignRecord = ref object of TES3Record
        spell_ids*: seq[string]
        texture_file_name*: Option[string] = none(string)
        description*: Option[string] = none(string)
    CellRecord = ref object of TES3Record
        data*: CellData
        region_name*: Option[string] = none(string)
        map_color*: Option[RGBA] = none(RGBA)
        water_height*: Option[float32] = none(float32)
        ambient_light*: Option[AmbientLight] = none(AmbientLight)
        moved_references*: seq[MovedRef] = @[]
        form_references*: seq[FormRef] = @[]
        count_temp_children*: Option[uint32] = none(uint32)
        temporary_references*: seq[FormRef] = @[]
    ClassRecord = ref object of TES3Record
        data*: ClassData
        description*: Option[string] = none(string)
    ClothingRecord = ref object of TES3Record
        data*: ClothingData
        icon_name*: Option[string] = none(string)
        biped_objects*: seq[BipedObject] = @[]
        enchantment_name*: Option[string] = none(string)
    ContainerItem = object
        count*:int32
        name*:string
    ContainerRecord = ref object of TES3Record
        weight*: float32
        container_flags*: seq[ContainerFlags]
        container_objects*: seq[ContainerItem] = @[]
    HeldItem = object 
        count*:uint32
        name*:string
    CreatureRecord = ref object of TES3Record
        sound_gen_creature*: Option[string] = none(string)
        data*: CreatureData
        creature_flags*: seq[CreatureFlags]
        scale*: float32 = 1.0
        carried_objects*: seq[HeldItem] = @[]
        ai_data*: AIData
        cell_travel_data*: seq[CellTravel] = @[]
        spells*: seq[string] = @[]
    DialogueRecord = ref object of TES3Record
        data*: uint8
    DoorRecord = ref object of TES3Record
        sound_open*: Option[string] = none(string)
        sound_close*: Option[string] = none(string)
    EnchantmentRecord = ref object of TES3Record
        data*: EnchantmentData
        enchantments*: seq[Enchantment] = @[]
    FactionReaction = object 
        faction_name*:string
        reaction*: int32
    FactionRecord = ref object of TES3Record
        rank_names*: seq[string] = @[]
        data*: FactionData
        reactions*: seq[FactionReaction] = @[]
    GlobalRecord = ref object of TES3Record
        global_type*: char
        value*: float32
    GameSettingRecord = ref object of TES3Record
        float_value*: Option[float32] = none(float32)
        int_value*: Option[int32] = none(int32)
        str_value*: Option[string] = none(string)
    DialogueInfoRecord = ref object of TES3Record
        info_name*: string
        previous_info_id*: string
        next_info_id*: string
        data*: Option[InfoData] = none(InfoData)
        actor_name*: Option[string] = none(string)
        race_name*: Option[string] = none(string)
        class_name*: Option[string] = none(string)
        faction_name*: Option[string] = none(string)
        cell_name*: Option[string] = none(string)
        player_faction*: Option[string] = none(string)
        sound_name*: Option[string] = none(string)
        response_text*: Option[string] = none(string)
        dialogue_filters*: seq[FilterData] = @[]
        result_text*: Option[string] = none(string)
        is_quest_name*: Option[bool] = none(bool)
        is_quest_finished*: Option[bool] = none(bool)
        is_quest_restart*: Option[bool] = none(bool)
    IngredientRecord = ref object of TES3Record
        data*: IngredientData
        icon_name*: Option[string] = none(string)
    VertexNormals = array[0..64,array[0..64,Grid3D[int8]]]
    VertexColors = array[0..64,array[0..64,RGB]]
    TextureIndices = array[0..15,array[0..15,uint16]]
    LeveledListItem = object 
        name*:string
        pc_level*:uint16
    LandscapeRecord = ref object of TES3Record
        coordinates*: Grid2D[int32]
        data*: uint32
        vertex_normals*: Option[VertexNormals] = none(VertexNormals)
        height_data*: Option[HeightData] = none(HeightData)
        world_map_heights*: Option[array[0..8, array[0..8, uint8]]] = none(array[0..8, array[0..8, uint8]])
        vertex_colors*: Option[VertexColors] = none(VertexColors)
        texture_indices*: Option[TextureIndices] = none(TextureIndices)
    LeveledCreatureRecord = ref object of TES3Record
        data*: uint32
        chance_none*: uint8
        creatures*: seq[LeveledListItem] = @[]
    LeveledItemRecord = ref object of TES3Record
        data*: uint32
        chance_none*: uint8
        items*: seq[LeveledListItem] = @[]
    LightRecord = ref object of TES3Record
        icon_name*: Option[string] = none(string)
        data*: LightData
        sound_name*: Option[string] = none(string)
    LockRecord = ref object of TES3Record
        data*: LockData
        icon_name*: Option[string] = none(string)
    LandscapeTextureRecord = ref object of TES3Record
        index*: uint32
        data*: string
    MagicEffectRecord = ref object of TES3Record
        index*: uint32
        data*: MagicEffectData
        effect_icon*: Option[string] = none(string)
        particle_texture*: Option[string] = none(string)
        bolt_sound*: Option[string] = none(string)
        casting_sound*: Option[string] = none(string)
        hit_sound*: Option[string] = none(string)
        area_sound*: Option[string] = none(string)
        casting_visual*: Option[string] = none(string)
        bolt_visual*: Option[string] = none(string)
        hit_visual*: Option[string] = none(string)
        area_visual*: Option[string] = none(string)
        description_text*: Option[string] = none(string)
    MiscRecord = ref object of TES3Record
        data*: MiscWeaponData
        icon_name*: Option[string] = none(string)
    NPCRecord = ref object of TES3Record
        race_name*: string
        class_name*: string
        faction_name*: Option[string] = none(string)
        head_model*: string
        hair_model*: Option[string] = none(string)
        data*: NPCData
        npc_flags*: seq[NPCFlags]
        carried_objects*: seq[HeldItem] = @[]
        spells*: seq[string]
        ai_data*: AIData
        cell_travel_data*: seq[CellTravel] = @[]
        ai_packages*: seq[AIPackage] = @[]
    PathGridRecord = ref object of TES3Record
        data*: PathGridData
        path_points*: seq[PathPoint]
        connection_list*: seq[uint32]
    ProbeRecord = ref object of TES3Record
        data*: ProbeData
        icon_name*: Option[string] = none(string)
    RaceRecord = ref object of TES3Record
        data*: RaceData
        powers*: seq[string] = @[]
        description*: Option[string] = none(string)
    WeatherChances = object
        clear,cloudy,foggy,overcast,rain,thunder,ash,blight*:uint8
        snow,blizzard*:Option[uint8]
    SoundChance = object 
        name*:string
        chance*:uint8
    RegionRecord = ref object of TES3Record
        weather_chances*: WeatherChances
        sleep_creature*: Option[string] = none(string)
        map_color*: RGBA
        sound_chances*: seq[SoundChance] = @[]
    RepairToolRecord = ref object of TES3Record
        data*: RepairData
        icon_name*: Option[string] = none(string)
    ScriptVariables = object 
        shorts*:seq[string]
        longs*:seq[string]
        floats*:seq[string]
    ScriptRecord = ref object of TES3Record
        script_header*: ScriptHeader
        script_variables*: Option[ScriptVariables] = none(ScriptVariables)
        compiled_data*: seq[uint8]
        script_text*: string
    SkillRecord = ref object of TES3Record
        index*: uint32
        data*: SkillData
        description*: Option[string] = none(string)
    SoundGeneratorRecord = ref object of TES3Record
        name*: string # replace with id
        data*: uint32
        creature_name*: Option[string] = none(string)
        sound_id*: Option[string] = none(string)
    AttenuationData = object
        volume,min,max*:uint8
    SoundRecord = ref object of TES3Record
        data*: AttenuationData
    SpellRecord = ref object of TES3Record
        data*: SpellData
        enchantments*: seq[Enchantment] = @[]
    StartScriptRecord = ref object of TES3Record
        data*: string
    StaticRecord = ref object of TES3Record
    TES3HeaderRecord = ref object of TES3Record
        header*: HeaderData
        masters*: seq[MasterFile] = @[]
    WeaponRecord = ref object of TES3Record
        data*: WeaponData
        icon_name*: Option[string] = none(string)
        enchantment_id*: Option[string] = none(string)
    TES3File* = object
        activators*: seq[ActivatorRecord] = @[]
        potions*: seq[PotionRecord] = @[]
        alchemy_apparatus*: seq[AlchemyApparatusRecord] = @[]
        armor: seq[ArmorRecord] = @[]
        body_parts: seq[BodyRecord] = @[]
        books: seq[BookRecord] = @[]
        birthsigns: seq[BirthSignRecord] = @[]
        cells: seq[CellRecord] = @[]
        classes: seq[ClassRecord] = @[]
        clothing: seq[ClothingRecord] = @[]
        containers: seq[ContainerRecord] = @[]
        creatures: seq[CreatureRecord] = @[]
        dialogue: seq[DialogueRecord] = @[]
        doors: seq[DoorRecord] = @[]
        enchantments: seq[EnchantmentRecord] = @[]
        factions: seq[FactionRecord] = @[]
        globals: seq[GlobalRecord] = @[]
        game_settings: seq[GameSettingRecord] = @[]
        dialogue_topics: seq[DialogueInfoRecord] = @[]
        ingredients: seq[IngredientRecord] = @[]
        landscapes: seq[LandscapeRecord] = @[]
        leveled_creatures: seq[LeveledCreatureRecord] = @[]
        leveled_items: seq[LeveledItemRecord] = @[]
        lights: seq[LightRecord] = @[]
        locks: seq[LockRecord] = @[]
        land_textures: seq[LandscapeTextureRecord] = @[]
        magic_effects: seq[MagicEffectRecord] = @[]
        miscellaneous: seq[MiscRecord] = @[]
        npcs: seq[NPCRecord] = @[]
        pathgrids: seq[PathGridRecord] = @[]
        probes: seq[ProbeRecord] = @[]
        races: seq[RaceRecord] = @[]
        regions: seq[RegionRecord] = @[]
        repair_items: seq[RepairToolRecord] = @[]
        scripts: seq[ScriptRecord] = @[]
        skills: seq[SkillRecord] = @[]
        sound_generators: seq[SoundGeneratorRecord] = @[]
        sounds: seq[SoundRecord] = @[]
        spells: seq[SpellRecord] = @[]
        start_scripts: seq[StartScriptRecord] = @[]
        statics: seq[StaticRecord] = @[]
        header: TES3HeaderRecord
        weapons: seq[WeaponRecord] = @[]


using
    s:Stream
    ts:TES3File

proc checkTag*(a, b: string) = assert(a == b, fmt"Tag {a} does not match Tag {b}")
proc checkSize*(a, b: int) = assert(a == b,fmt"Size of {a} does not match Size of {b}")

proc skip(s;pos:Natural) = s.setPosition(s.getPosition() + pos)

proc `%`*(c:char):JsonNode =
    result = newJString($c)

proc `%`*(r:RGBA):JsonNode =
    result = newJObject()
    result["r"] = %r.r
    result["g"] = %r.g
    result["b"] = %r.b

proc `%`*(r:Grid2D):JsonNode =
    result = newJObject()
    result["x"] = %r.x
    result["y"] = %r.y

proc readTag(s): string = s.readStr(TAGSIZE)
proc peekTag(s): string = s.peekStr(TAGSIZE)

template preamble(tag:string):untyped =
    checkTag(s.readTag(),tag)
    result.size = s.readUint32()
    s.skip(4)
    result.flags = toRecordFlags(s.readUint32())
    

#### Read TES File

proc readStrField(s: Stream, tag: string): string =
    checkTag(s.readStr(TAGSIZE), tag)
    let size = s.readUint32()
    result = stripEverything(s.readStr(size.int))

proc readUint8Field(s;tag:string):uint8 =
    checkTag(s.readStr(TAGSIZE),tag)
    checkSize(s.readUint32().int,SZ8)
    result = s.readUint8() 

proc readInt8Field(s;tag:string):int8 =
    checkTag(s.readStr(TAGSIZE),tag)
    checkSize(s.readUint32().int,SZ8)
    result = s.readInt8()

proc readUint16Field(s;tag:string):uint16 =
    checkTag(s.readStr(TAGSIZE),tag)
    checkSize(s.readUint32().int,SZ16)
    result = s.readUint16() 

proc readUint32Field(s;tag:string):uint32 =
    checkTag(s.readStr(TAGSIZE),tag)
    checkSize(s.readUint32().int,SZ32)
    result = s.readUint32()

proc readInt32Field(s;tag:string):int32 =
    checkTag(s.readStr(TAGSIZE),tag)
    checkSize(s.readUint32().int,SZ32)
    result = s.readInt32()

proc readFloat32Field(s;tag:string):float32 =
    checkTag(s.readStr(TAGSIZE),tag)
    checkSize(s.readUint32().int,SZ32)
    result = s.readFloat32()

proc readDataField[T](s;data:var T,tag:string) = 
    checkTag(s.readTag(),tag)
    discard s.readUint32()
    s.read(data)

## JSON

template fromjsonpreamble(): untyped =
    result.size = node["size"].to(uint32)
    result.flags = toRecordFlags(node["flags"].to(uint32))
    result.id = node["id"].getStr()
    if node.hasKey("dele"):
        result.dele = node["dele"].getBool()
    if node.hasKey("model_name"):
        result.model_name = node["model_name"].getStr().some
    if node.hasKey("full_name"):
        result.full_name = node["full_name"].getStr().some
    if node.hasKey("script_name"):
        result.script_name = node["script_name"].getStr().some

template tojsonpreamble():untyped =
    result["kind"] = %($r.kind)
    result["id"] = %r.id
    result["flags"] = %r.flags
    if r.model_name.isSome:
        result["model_name"] = %r.model_name
    if r.model_name.isSome:
        result["full_name"] = %r.full_name
    if r.model_name.isSome:
        result["script_name"] = %r.script_name

### Write TES File

proc writeStrField(s;tag,data:string) =
    s.write(tag)
    s.write(len(data))
    s.write(data)

proc writeField[T](s;tag:string,data:T) =
    s.write(tag)
    s.write(sizeof(data))
    s.write(data)

template writepreamble(kind:TES3Kind):untyped =
    s.write($kind)
    s.write(r.size)
    s.write(r.flags)
    s.writeStrField(NAME,r.id)
    if r.dele == true: discard # what should be written....
    if r.model_name.isSome():
        s.writeStrField(MODL,r.model_name.get())
    if r.full_name.isSome():
        s.writeStrField(FNAM,r.full_name.get())
    if r.script_name.isSome():
        s.writeStrField(SCRI,r.script_name.get())

proc readActivator*(s): ActivatorRecord =
    result = ActivatorRecord(kind: ACTI)
    preamble($ACTI)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else: break

proc readActivator*(node:JsonNode): ActivatorRecord =
    result = ActivatorRecord(kind: ACTI)
    fromjsonpreamble()

proc writeActivator*(s;r:ActivatorRecord) = writepreamble(ACTI)

proc `%`*(r:ActivatorRecord): JsonNode =
    result = newJObject()
    tojsonpreamble()



proc readAlchemy*(s): PotionRecord =
    result = PotionRecord(kind: ALCH)
    preamble($ALCH)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of TEXT:
                result.icon_name = s.readStrField(TEXT).some
            of ALDT:
                var AlchData: AlchemyData
                s.readDataField(AlchData,ALDT)
                result.data = AlchData
            of ENAM:
                var Enchant: Enchantment
                s.readDataField(Enchant,ENAM)
                result.enchantments.add(Enchant)
            else: break

proc readAlchemy*(node:JsonNode): PotionRecord =
    result = PotionRecord(kind: ALCH)
    for k,v in pairs(node):
        case k:
            of "size":
                result.size = v.to(uint32)
            of "id":
                result.id = v.getStr()
            of "model_name":
                result.model_name = v.getStr().some
            of "icon_name":
                result.icon_name = v.getStr().some
            of "data":
                result.data = v.to(AlchemyData)
            of "enchantments":
                result.enchantments = v.to(seq[Enchantment])
            else: discard



proc `%`(d:AlchemyData):JsonNode =
    result = newJObject()
    result["weight"] = %d.weight
    result["value"] = %d.value
    result["flags"] = %d.flags

proc `%`*(r:PotionRecord):JsonNode =
    result = newJObject()
    tojsonpreamble()
    result["icon_name"] = %r.icon_name
    result["data"] = %r.data
    result["enchantments"] = %r.enchantments

proc writeAlchemy*(s;r:PotionRecord) =
    writepreamble(ALCH)
    if r.icon_name.isSome():
        s.writeStrField(TEXT,r.icon_name.get())
    s.writeField(DATA,r.data)
    if len(r.enchantments) > 0:
        for x in r.enchantments:
            s.writeField(ENAM,x)

    

proc readApparatus*(s): AlchemyApparatusRecord =
    result = AlchemyApparatusRecord(kind: APPA)
    preamble($APPA)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of AADT:
                var data: AlchemyApparatusData
                s.readDataField(data, AADT)
                result.data = data.some
            else: break

proc `%`*(r:AlchemyApparatusRecord):JsonNode =
    result = newJObject()
    tojsonpreamble()
    if r.icon_name.isSome():
        result["icon_name"] = %r.icon_name.get()
    if r.data.isSome():
        result["data"] = %r.data

proc writeApparatus*(s;r:AlchemyApparatusRecord) = 
    writepreamble(APPA)
    if r.icon_name.isSome():
        s.writeStrField(TEXT,r.icon_name.get())
    if r.data.isSome():
        s.writeField(AADT,r.data.get())

proc readBipedObject(s;tag:string): BipedObject =
    checkTag(s.readStr(TAGSIZE), tag)
    result = BipedObject()
    let size = s.readUint32()
    if size == SZ8:
        result.kind = s.readUint8()
    if size == SZ32:
        result.kind = s.readUint32()
    var tag = s.peekTag()
    if tag == BNAM:
        result.bnam = s.readStrField(BNAM).some
    tag = s.peekTag()
    if tag == CNAM:
        result.cnam = s.readStrField(CNAM).some


proc readArmor*(s): ArmorRecord =
    result = ArmorRecord(kind: ARMO)
    preamble($ARMO)
    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of INDX:
                result.biped_objects.add(s.readBipedObject(INDX))
            of ENAM:
                result.enchantment_name = s.readStrField(ENAM).some
            of AODT:
                var data: ArmorData
                s.readDataField(data, AODT)
                result.data = data
            else: break

proc readBirthsign*(s): BirthSignRecord =
    result = BirthSignRecord(kind: BSGN)
    preamble($BSGN)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id =  s.readStrField(NAME)
            of FNAM:
                result.full_name =  s.readStrField(FNAM).some
            of TNAM:
                result.texture_file_name =  s.readStrField(TNAM).some
            of DESC:
                result.description = s.readStrField(DESC).some
            of NPCS:
                result.spell_ids.add(s.readStrField(NPCS))
            else: break


proc readBody*(s): BodyRecord =
    result = BodyRecord(kind: BODY)
    preamble($BODY)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of BYDT:
                var data = BodyPartData()
                checkTag(s.readTag(),BYDT)
                s.skip(4)
                data.part = BodyPart(s.readUint8())
                data.vampire = s.readUint8()
                data.flags = parseBodyFlags(s.readUint8())
                data.partKind = BodyPartKind(s.readUint8())
                result.data = data
            else: break

proc readBook*(s): BookRecord =
    result = BookRecord(kind: BOOK)
    preamble($BOOK)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of TEXT:
                result.text = s.readStrField(TEXT).some
            of ENAM:
                result.enchantment_name = s.readStrField(ENAM).some
            of BKDT:
                var data: BookData
                s.readDataField(data, BKDT)
                result.data = data
            else: break

proc readFormRef(s): FormRef =
    result = FormRef()

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of FRMR:
                result.frmr = s.readUint32Field(FRMR)
            of NAME:
                result.name = s.readStrField(NAME)
            of UNAM:
                result.unam = s.readUint8Field(UNAM).some
            of XSCL:
                result.xscl = s.readFloat32Field(XSCL).some
            of ANAM:
                result.anam = s.readStrField(ANAM).some
            of BNAM:
                result.bnam = s.readStrField(BNAM).some
            of CNAM:
                result.cnam = s.readStrField(CNAM).some
            of INDX:
                result.indx = s.readUint32Field(INDX).some
            of XSOL:
                result.xsol = s.readStrField(XSOL).some
            of XCHG:
                result.xchg = s.readFloat32Field(XCHG).some
            of INTV:
                result.intv = s.readFloat32Field(INTV).some
            of NAM9:
                result.nam9 = s.readUint32Field(NAM9).some
            of DODT:
                var data: Coords3D
                var dnamdata = none(string)
                s.readDataField(data, DODT)
                let subtag = s.peekTag()
                if subtag == DNAM:
                    dnamdata = s.readStrField(DNAM).some
                result.cellTravel.add(CellTravel(destination: data, previous_cell: dnamdata))
            of FLTV:
                result.fltv = s.readFloat32Field(FLTV).some
            of KNAM:
                result.knam = s.readStrField(KNAM).some
            of TNAM:
                result.tnam = s.readStrField(TNAM).some
            of ZNAM:
                result.znam = s.readUint8Field(ZNAM).some
            of DATA:
                var data: Coords3D
                s.readDataField(data, DATA)
                result.data = data.some
            else: break

proc readMovedRef*(s): MovedRef =
    result = MovedRef()
    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of MVRF:
                result.mvrf = s.readUint32Field(MVRF)
            of CNAM:
                result.cnam = s.readStrField(CNAM).some
            of CNDT:
                var grid:Grid2D[int32]
                s.readDataField(grid,CNDT)
                result.cndt = grid.some
            of FRMR:
                result.frmr = s.readFormRef().some
            else: break



proc readCell*(s): CellRecord =
    result = CellRecord(kind: CELL)
    preamble($CELL)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of DATA:
                checkTag(s.readTag(),DATA)
                s.skip(4)
                var data = CellData()
                data.flags = parseCellDataFlags(s.readUint32())
                data.gridX = s.readInt32()
                data.gridY = s.readInt32()
                result.data = data
            of RGNN:
                result.region_name = s.readStrField(RGNN).some
            of NAM5:
                var color: RGBA
                s.readDataField(color, NAM5)
                result.map_color = color.some
            of WHGT:
                result.water_height = s.readFloat32Field(WHGT).some
            of AMBI:
                var ambi: AmbientLight
                s.readDataField(ambi, AMBI)
                
                result.ambient_light = ambi.some
            of MVRF:
                result.moved_references.add(s.readMovedRef())
            of NAM0:
                result.count_temp_children = s.readUint32Field(NAM0).some
            of FRMR:
                if result.count_temp_children.isSome():
                    result.temporary_references.add(s.readFormRef())
                else:
                    result.form_references.add(s.readFormRef())
            of INTV:
                result.water_height = s.readInt32Field(INTV).float32.some
            else: 
                break


proc readClass*(s): ClassRecord =
    result = ClassRecord(kind: CLAS)
    preamble($CLAS)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of DESC:
                result.description = s.readStrField(DESC).some
            of CLDT:
                result.data = ClassData()
                checkTag(s.readStr(TAGSIZE),CLDT)
                s.skip(4)
                result.data.attribute = AttributeDuo(one: s.readUint32(),two: s.readUint32())
                result.data.specialization = s.readUint32()
                for idx in 1..5:
                    result.data.minorSkills.add(s.readUint32())
                    result.data.majorSkills.add(s.readUint32())
                result.data.flags = parseClassAutoCalcFlags(s.readUint32())
                result.data.autoCalc = s.readUint32()
            else:
                break

proc readClothing*(s): ClothingRecord =
    result = ClothingRecord(kind: CLOT)
    preamble($CLOT)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of CTDT:
                var data: ClothingData
                s.readDataField(data,CTDT)
                result.data = data
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of INDX:
                result.biped_objects.add(s.readBipedObject(INDX))
            of ENAM:
                result.enchantment_name = s.readStrField(ENAM).some
            else:
                break

proc readContainer*(s): ContainerRecord =
    result = ContainerRecord(kind: CONT)
    preamble($CONT)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of CNDT:
                result.weight = s.readFloat32Field(CNDT)
            of FLAG:
                result.container_flags = parseContainerFlags(s.readUint32Field(FLAG))
            of NPCO:
                checkTag(s.readTag(),NPCO)
                let size = s.readUint32() #size
                let count = s.readInt32()
                let name = s.readStr(size.int - SZ32)
                result.container_objects.add(ContainerItem(count:count,name:name))
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else:
                break

proc readCreature*(s): CreatureRecord =
    result = CreatureRecord(kind: CREA)
    preamble($CREA)
    var tag:string

    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of CNAM:
                result.sound_gen_creature = s.readStrField(CNAM).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of NPDT:
                var data:CreatureData
                s.readDataField(data,NPDT)
                result.data = data
            of FLAG:
                result.creature_flags = parseCreatureFlags(s.readUint32Field(FLAG))
            of XSCL:
                result.scale = s.readFloat32Field(XSCL)
            of NPCO:
                checkTag(s.readStr(TAGSIZE),NPCO)
                let size = s.readUint32() #size
                let count = s.readUint32()
                let name = s.readStr(size.int - SZ32)
                result.carried_objects.add(HeldItem(count:count,name:name))
            of NPCS:
                result.spells.add(s.readStrField(NPCS))
            of AIDT:
                # 000000011100100000 00000000000000
                checkTag(s.readTag(),AIDT)
                s.skip(4)
                var data = AIData()
                data.hello = s.readUint8()
                data.unknown = s.readUint8()
                data.fight = s.readUint8()
                data.flee = s.readUint8()
                data.alarm = s.readUint8()
                s.skip(3) # junk data
                data.flags = parseAIFlags(s.readUint32())
                result.ai_data = data
            of DODT:
                var data: Coords3D
                var dnamdata = none(string)
                s.readDataField(data, DODT)
                let subtag = s.peekTag()
                if subtag == DNAM:
                    checkTag(s.readStr(TAGSIZE), DNAM)
                    dnamdata = s.readStrField(DNAM).some
                result.cell_travel_data.add(CellTravel(destination: data,previous_cell: dnamdata))
            of AIA:
                checkTag(s.readTag(),AIA)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIActivate)
                pkg.aianame = s.readStr(32)
                s.skip(1)
            of AIE:
                checkTag(s.readStr(TAGSIZE),AIE)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIEscort)
                pkg.aiex = s.readFloat32()
                pkg.aiey = s.readFloat32()
                pkg.aiez = s.readFloat32()
                pkg.aieduration = s.readUint16()
                pkg.aieid = s.readStr(32)
                s.skip(2)
                tag = s.peekTag()
                if tag == CNDT:
                    pkg.aiecndt = s.readStrField(CNDT).some

            of AIF:
                checkTag(s.readTag(),AIF)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIFollow)
                pkg.aifx = s.readFloat32()
                pkg.aify = s.readFloat32()
                pkg.aifz = s.readFloat32()
                pkg.aifduration = s.readUint16()
                pkg.aifid = s.readStr(32)
                s.skip(2)
                tag = s.peekTag()
                if tag == CNDT:
                    pkg.aifcndt = s.readStrField(CNDT).some
            of AIT:
                checkTag(s.readTag(),AIT)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AITravel)
                pkg.aitx = s.readFloat32()
                pkg.aity = s.readFloat32()
                pkg.aitz = s.readFloat32()
                s.skip(4)
            of AIW:
                checkTag(s.readTag(),AIW)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIWander)
                pkg.aiwdistance = s.readUint16()
                pkg.aiwduration = s.readUint16()
                pkg.aiwtimeofday = s.readUint8()
                s.read(pkg.aiwidles)
                s.skip(1)
            else:
                break

proc readDialogue(s):DialogueRecord =
    result = DialogueRecord(kind: DIAL)
    preamble($DIAL)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of DATA:
                result.data = s.readUint8Field(DATA)
            else:
                break

proc readDoor(s):DoorRecord =
    result = DoorRecord(kind: DOOR)
    preamble($DOOR)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of SNAM:
                result.sound_open = s.readStrField(SNAM).some
            of ANAM:
                result.sound_close = s.readStrField(ANAM).some
            else: break

proc readEnchantment(s): EnchantmentRecord =
    result = EnchantmentRecord(kind: ENCH)
    preamble($ENCH)


    var tag:string  
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of ENDT:
                var data: EnchantmentData
                s.readDataField(data,ENDT)
                result.data = data
            of ENAM:
                var data: Enchantment
                s.readDataField(data,ENAM)
                result.enchantments.add(data)
            else: break

proc readFaction(s):FactionRecord =
    result = FactionRecord(kind: FACT)
    preamble($FACT)


    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of RNAM:
                result.rank_names.add(s.readStrField(RNAM))
            of FADT:
                var data:FactionData
                s.readDataField(data,FADT)
                result.data = data
            of ANAM:
                let name = s.readStrField(ANAM)
                checkTag(s.readStr(TAGSIZE),INTV)
                discard s.readUint32() #size
                let intv = s.readInt32()
                result.reactions.add(FactionReaction(faction_name:name,reaction:intv))
            else: break

proc readGlobal*(s): GlobalRecord =
    result = GlobalRecord(kind: GLOB)
    preamble($GLOB)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of FNAM:
                checkTag(s.readTag(),FNAM)
                discard s.readUint32()
                result.global_type = s.readChar()
            of NAME:
                result.id = s.readStrField(NAME)
            of FLTV:
                checkTag(s.readTag(),FLTV)
                discard s.readUint32()
                result.value = s.readFloat32()
            of DELE:
                checkTag(s.readTag(),DELE)
                let size = s.readUint32()
                s.skip(size.int)
            else: 
                break



proc readGMST*(s): GameSettingRecord =
    result = GameSettingRecord(kind: GMST)
    preamble($GMST)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of STRV:
                result.str_value = s.readStrField(STRV).some
            of INTV:
                result.int_value = s.readInt32Field(INTV).some
            of FLTV:
                result.float_value = s.readFloat32Field(FLTV).some
            else: 
                break

proc readInfo(s): DialogueInfoRecord =
    result = DialogueInfoRecord(kind: INFO)
    preamble($INFO)

    var tag:string
    while true:
        tag = s.peekTag()
        
        case tag:
            of INAM:
                result.info_name = s.readStrField(INAM)
            of PNAM:
                result.previous_info_id = s.readStrField(PNAM)
            of NNAM:
                result.next_info_id = s.readStrField(NNAM)
            of DATA:
                checkTag(s.readStr(TAGSIZE),DATA)
                discard s.readUint32()
                var data = InfoData()
                data.kind = s.readUint8()
                s.skip(3)
                data.disposition = s.readUint32()
                data.rank = s.readInt8()
                data.gender = s.readInt8()
                data.pcrank = s.readInt8()
                s.skip(1)
                result.data = data.some
            of ONAM:
                result.actor_name = s.readStrField(ONAM).some
            of RNAM:
                result.race_name = s.readStrField(RNAM).some
            of CNAM:
                result.class_name = s.readStrField(CNAM).some
            of FNAM:
                result.faction_name = s.readStrField(FNAM).some
            of ANAM:
                result.cell_name = s.readStrField(ANAM).some
            of DNAM:
                result.player_faction = s.readStrField(DNAM).some
            of SNAM:
                result.sound_name = s.readStrField(SNAM).some
            of NAME:
                result.response_text = s.readStrField(NAME).some
            of SCVR:
                checkTag(s.readStr(TAGSIZE),SCVR)
                discard s.readUint32()
                var filter = FilterData()
                filter.kind = FilterFunctionKind(s.readChar())
                filter.index = s.readChar()
                filter.details = s.readStr(2)
                filter.op = s.readChar()
                let size = s.readUint32()
                filter.name = s.readStr(size.int)

                tag = s.peekStr(TAGSIZE)
                if tag == INTV:
                    checkTag(s.readStr(TAGSIZE),INTV)
                    filter.comparison_int = s.readUint32().some
                tag = s.peekStr(TAGSIZE)
                if tag == FLTV:
                    filter.comparison_float = s.readFloat32Field(FLTV).some
                
                result.dialogue_filters.add(filter)
            of BNAM:
                result.result_text = s.readStrField(BNAM).some
            of QSTN:
                result.is_quest_name = s.readInt8Field(QSTN).bool.some
            of QSTF:
                result.is_quest_finished = s.readInt8Field(QSTF).bool.some
            of QSTR:
                result.is_quest_restart = s.readInt8Field(QSTR).bool.some
            else: break

proc readIngredient(s):IngredientRecord =
    result = IngredientRecord(kind:INGR)
    preamble($INGR)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of IRDT:
                var data:IngredientData
                s.readDataField(data,IRDT)
                result.data = data
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            else: break       

proc readLand(s):LandscapeRecord =
    result = LandscapeRecord(kind: LAND)
    preamble($LAND)

    var tag:string
    while true:
        tag = s.peekTag()
        echo tag
        case tag:
            of INTV:
                var grid:Grid2D[int32]
                s.readDataField(grid,INTV)
                result.coordinates = grid
            of DATA:
                result.data = s.readUint32Field(DATA)
            of VNML:
                var nrmls:array[0..64, array[0..64, Grid3D[int8]]]
                s.readDataField(nrmls,VNML)
                result.vertex_normals = nrmls.some
            of VHGT:
                var heights:HeightData
                s.readDataField(heights,VHGT)
                result.height_data = heights.some 
            of WNAM:
                var wmap:array[0..8, array[0..8, uint8]]
                s.readDataField(wmap,WNAM)
                result.world_map_heights = wmap.some
            of VCLR:
                var vcolors: array[0..64, array[0..64, RGB]]
                s.readDataField(vcolors,VCLR)
                result.vertex_colors = vcolors.some
            of VTEX:
                var vtextures:array[0..15, array[0..15, uint16]]
                s.readDataField(vtextures,VTEX)
                result.texture_indices = vtextures.some
            else: break
    

proc readLeveledCreature(s): LeveledCreatureRecord =
    result = LeveledCreatureRecord(kind: LEVC)
    preamble($LEVC)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of DATA:
                result.data = s.readUint32Field(DATA)
            of NNAM:
                result.chance_none = s.readUint8Field(NNAM)
            of INDX: s.skip(TAGSIZE + 4 + 4)
            of CNAM:
                let name = s.readStrField(CNAM)
                let level = s.readUint16Field(INTV)
                result.creatures.add(LeveledListItem(name: name,pc_level: level))
            else: break

proc readLeveledItem(s): LeveledItemRecord =
    result = LeveledItemRecord(kind: LEVI)
    preamble($LEVI)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of DATA:
                result.data = s.readUint32Field(DATA)
            of NNAM:
                result.chance_none = s.readUint8Field(NNAM)
            of INDX: 
                s.skip(TAGSIZE + 4 + 4)
            of INAM:
                let name = s.readStrField(INAM)
                let level = s.readUint16Field(INTV)
                result.items.add(LeveledListItem(name: name,pc_level: level))
            else: break

proc readLight(s):LightRecord =
    result = LightRecord(kind: LIGH)
    preamble($LIGH)

    var tag:string  
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of LHDT:
                var data = LightData()
                checkTag(s.readTag(),LHDT)
                s.skip(4)
                data.weight = s.readFloat32()
                data.value = s.readUint32()
                data.time = s.readInt32()
                data.radius = s.readUint32()
                s.read(data.color)
                data.flags = parseLightFlags(s.readUint32())
                result.data = data
            of SNAM:
                result.sound_name = s.readStrField(SNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else:break

proc readLock(s):LockRecord =
    result = LockRecord(kind: LOCK)
    preamble($LOCK)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of LKDT:
                var data:LockData
                s.readDataField(data,LKDT)
                result.data = data
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            else:
                break

proc readLandTexture(s):LandscapeTextureRecord =
    result = LandscapeTextureRecord(kind: LTEX)
    preamble($LTEX)

    var tag:string
    while true:
        tag = s.peekTag()
        echo tag
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of INTV:
                result.index = s.readUint32Field(INTV)
            of DATA:
                result.data = s.readStrField(DATA)
            else: break
            
proc readMagicEffect(s):MagicEffectRecord =
    result = MagicEffectRecord(kind: MGEF)
    preamble($MGEF)

    var tag:string
    while true:
        tag = s.peekTag()
        echo tag
        case tag:
            of INDX:
                result.index = s.readUint32Field(INDX)
            of MEDT:
                var data = MagicEffectData()
                checkTag(s.readTag(),MEDT)
                s.skip(4)
                data.school = s.readUint32()
                data.baseCost = s.readFloat32()
                data.flags = parseMagicEffectFlags(s.readUint32())
                data.red = s.readUint32()
                data.green = s.readUint32()
                data.blue = s.readUint32()
                data.speedX = s.readFloat32()
                data.sizeX = s.readFloat32()
                data.sizeCap = s.readFloat32()
                result.data = data
            of ITEX:
                result.effect_icon = s.readStrField(ITEX).some
            of PTEX:
                result.particle_texture = s.readStrField(PTEX).some
            of BSND:
                result.bolt_sound = s.readStrField(BSND).some
            of CSND:
                result.casting_sound = s.readStrField(CSND).some
            of HSND:
                result.hit_sound = s.readStrField(HSND).some
            of ASND:
                result.area_sound = s.readStrField(ASND).some
            of CVFX:
                result.casting_visual = s.readStrField(CVFX).some
            of BVFX:
                result.bolt_visual = s.readStrField(BVFX).some
            of HVFX:
                result.hit_visual = s.readStrField(HVFX).some
            of AVFX:
                result.area_visual = s.readStrField(AVFX).some
            of DESC:
                result.description_text = s.readStrField(DESC).some
            else: break

proc readMisc(s):MiscRecord =
    result = MiscRecord(kind: MISC)
    preamble($MISC)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of MCDT:
                var data:MiscWeaponData
                s.readDataField(data,MCDT)
                s.skip(4)
                result.data = data
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            else: break

proc readNPC(s):NPCRecord =
    result = NPCRecord(kind: NPC)
    preamble($NPC)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of RNAM:
                result.race_name = s.readStrField(RNAM)
            of CNAM:
                result.class_name = s.readStrField(CNAM)
            of ANAM:
                result.faction_name = s.readStrField(ANAM).some
            of BNAM:
                result.head_model = s.readStrField(BNAM)
            of KNAM:
                result.hair_model = s.readStrField(KNAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            of NPDT:
                var data:NPCData
                checkTag(s.readTag(),NPDT)
                let size = s.readUint32()
                data.level = s.readUint16()
                if size == 52:
                    var attr: AttributeArray
                    var skills: SkillArray
                    s.read(attr)
                    s.read(skills)
                    data.attributes = attr.some
                    data.skills = skills.some
                    s.skip(1)
                    data.health = s.readUint16().some
                    data.spell_points = s.readUint16().some
                    data.fatigue = s.readUint16().some
                
                data.disposition = s.readUint8()
                data.reputation = s.readUint8()
                data.rank = s.readUint8()
                if size == 52:
                    s.skip(1)
                else:
                    s.skip(3)
                data.gold = s.readUint32()
                result.data = data
            of FLAG:
                result.npc_flags = parseNPCFlags(s.readUint32Field(FLAG))
            of NPCO:
                checkTag(s.readTag(),NPCO)
                let size = s.readUint32()
                let count = s.readUint32()
                let name = s.readStr(size.int - SZ32)
                result.carried_objects.add(HeldItem(count: count,name: name))
            of NPCS:
                result.spells.add(s.readStrField(NPCS))
            of AIDT:
                checkTag(s.readTag(),AIDT)
                s.skip(SZ32)
                var data = AIData()
                data.hello = s.readUint8()
                echo data.hello
                data.unknown = s.readUint8()
                data.fight = s.readUint8()
                echo data.fight
                data.flee = s.readUint8()
                echo data.flee
                data.alarm = s.readUint8()
                echo data.alarm
                s.skip(3) # junk data
                var flags = s.readUint32()
                if result.id == "galbedir":
                    echo flags
                    assert(true == false,"breaking")
                data.flags = parseAIFlags(flags)
                result.ai_data = data
            of DODT:
                var data: Coords3D
                var dnamdata = none(string)
                s.readDataField(data, DODT)
                let subtag = s.peekTag()
                if subtag == DNAM:
                    dnamdata = s.readStrField(DNAM).some
                result.cell_travel_data.add(CellTravel(destination: data, previous_cell: dnamdata))
            of AIA:
                checkTag(s.readTag(),AIA)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIActivate)
                pkg.aianame = s.readStr(32)
                s.skip(1)
            of AIE:
                checkTag(s.readStr(TAGSIZE),AIE)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIEscort)
                pkg.aiex = s.readFloat32()
                pkg.aiey = s.readFloat32()
                pkg.aiez = s.readFloat32()
                pkg.aieduration = s.readUint16()
                pkg.aieid = s.readStr(32)
                s.skip(2)
                tag = s.peekTag()
                if tag == CNDT:
                    pkg.aiecndt = s.readStrField(CNDT).some

            of AIF:
                checkTag(s.readTag(),AIF)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIFollow)
                pkg.aifx = s.readFloat32()
                pkg.aify = s.readFloat32()
                pkg.aifz = s.readFloat32()
                pkg.aifduration = s.readUint16()
                pkg.aifid = s.readStr(32)
                s.skip(2)
                tag = s.peekTag()
                if tag == CNDT:
                    pkg.aifcndt = s.readStrField(CNDT).some
            of AIT:
                checkTag(s.readTag(),AIT)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AITravel)
                pkg.aitx = s.readFloat32()
                pkg.aity = s.readFloat32()
                pkg.aitz = s.readFloat32()
                s.skip(4)
            of AIW:
                checkTag(s.readTag(),AIW)
                discard s.readUint32() #size
                var pkg = AIPackage(kind: AIWander)
                pkg.aiwdistance = s.readUint16()
                pkg.aiwduration = s.readUint16()
                pkg.aiwtimeofday = s.readUint8()
                s.read(pkg.aiwidles)
                s.skip(1)
            else: break

proc readPathGrid(s): PathGridRecord =
    result = PathGridRecord(kind: PGRD)
    preamble($PGRD)

    var tag:string

    while true:
        tag = s.peekTag()
        echo "pathgrid ",tag
        case tag:
            of DATA:
                var data:PathGridData
                s.readDataField(data,DATA)
                result.data = data
            of NAME:
                result.id = s.readStrField(NAME)
            of PGRP:
                checkTag(s.readTag(),PGRP)
                s.skip(4)
                let size = result.data.point_count
                var data = PathPoint()
                for x in 0..<int(size):
                    data.location = Grid3D[int32](x: s.readInt32(),y: s.readInt32(),z: s.readInt32())
                    data.flags = s.readUint8()
                    data.connectionCount = s.readUint8()
                    s.skip(SZ16)
                    result.path_points.add(data)
                
            of PGRC:
                checkTag(s.readTag(),PGRC)
                let size = int(s.readUint32()) / 4
                for x in 0..<int(size):
                    result.connection_list.add(s.readUint32())
            of DELE:
                checkTag(s.readTag(),DELE)
                let size = s.readUint32()
                s.skip(int(size))
            else: 
                echo tag
                break

proc readProbe(s): ProbeRecord =
    result = ProbeRecord(kind: PROB)
    preamble($PROB)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL: 
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of PBDT:
                var data:ProbeData
                s.readDataField(data,PBDT)
                result.data = data
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else: break

proc readRace(s): RaceRecord = 
    result = RaceRecord(kind: RACE)
    preamble($RACE)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of RADT:
                var data = RaceData()
                checkTag(s.readTag(),RADT)
                s.skip(4)
                s.read(data.skillbonuses)
                s.read(data.attributes)
                s.read(data.height)
                s.read(data.weight)
                data.flags = parseRaceFlags(s.readUint32())
                result.data = data
            of NPCS:
                result.powers.add(s.readStrField(NPCS))
            of DESC:
                result.description = s.readStrField(DESC).some
            else: break

proc readRegion(s): RegionRecord =
    result = RegionRecord(kind: REGN)
    preamble($REGN)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of WEAT:
                checkTag(s.readTag(),WEAT)
                var chances = WeatherChances()
                let size = s.readUint32()
                chances.clear = s.readUint8()
                chances.cloudy = s.readUint8()
                chances.foggy = s.readUint8()
                chances.overcast = s.readUint8()
                chances.rain = s.readUint8()
                chances.thunder = s.readUint8()
                chances.ash = s.readUint8()
                chances.blight = s.readUint8()
                if size == 10:
                    chances.snow = s.readUint8().some
                    chances.blizzard = s.readUint8().some
                result.weather_chances = WeatherChances()
                
            of BNAM:
                result.sleep_creature = s.readStrField(BNAM).some
            of CNAM:
                var color: RGBA
                s.readDataField(color,CNAM)
                result.map_color = color
            of SNAM:
                checkTag(s.readTag(),SNAM)
                s.skip(4)
                let name = s.readStr(32)
                let chance = s.readUint8()
                result.sound_chances.add(SoundChance(name: name,chance: chance))
            else: break

proc readRepairTool(s): RepairToolRecord =
    result = RepairToolRecord(kind: REPA)
    preamble($REPA)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of RIDT:
                var data:RepairData
                s.readDataField(data,RIDT)
                result.data = data
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else: break

proc readScript(s): ScriptRecord =
    result = ScriptRecord(kind: SCPT)
    preamble($SCPT)

    var tag:string
    while true:
        tag = s.peekTag()
        echo tag
        case tag:
            of SCHD:
                checkTag(s.readTag(),SCHD)
                s.skip(4)
                var data = ScriptHeader()
                data.name = s.readStr(32)
                data.num_shorts = s.readUint32()
                data.num_longs = s.readUint32()
                data.num_floats = s.readUint32()
                data.script_data_size = s.readUint32()
                data.local_var_size = s.readUint32()
                result.script_header = data
            of SCVR:
                checkTag(s.readTag(),SCVR)
                let size = s.readUint32()
                var varlist = s.readStr(size.int).split(NULLRUNE)
                let num_shorts = result.script_header.num_shorts
                let num_longs = result.script_header.num_longs
                let num_floats = result.script_header.num_floats
                var shorts: seq[string] = @[]
                var longs: seq[string]  = @[]
                var floats: seq[string]  = @[]
                for s in 0..num_shorts:
                    shorts.add(varlist[s])
                for l in 0..num_longs:
                    longs.add(varlist[l+num_shorts])
                for f in 0..num_floats:
                    floats.add(varlist[f+num_shorts+num_longs])
                
                result.script_variables = ScriptVariables(shorts: shorts,longs: longs,floats: floats).some
                    
            of SCDT:
                checkTag(s.readTag(),SCDT)
                let size = s.readUint32()
                var data: seq[uint8] = @[]
                for x in 0..<int(size):
                    data.add(s.readUint8())
                result.compiled_data = data
            of SCTX:
                result.script_text = s.readStrField(SCTX)
            else: break

proc readSkill(s): SkillRecord = 
    result = SkillRecord(kind: SKIL)
    preamble($SKIL)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of INDX:
                result.index = s.readUint32Field(INDX)
            of SKDT:
                var data: SkillData
                s.readDataField(data,SKDT)
                result.data = data
            of DESC:
                result.description = s.readStrField(DESC).some
            else: 
                break

proc readSoundGenerator(s): SoundGeneratorRecord =
    result = SoundGeneratorRecord(kind: SNDG)
    preamble($SNDG)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of DATA:
                result.data = s.readUint32Field(DATA)
            of CNAM:
                result.creature_name = s.readStrField(CNAM).some
            of SNAM:
                result.sound_id = s.readStrField(SNAM).some
            else: break

proc readSound(s): SoundRecord =
    result = SoundRecord(kind: SOUN)
    preamble($SOUN)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of DATA:
                var data:AttenuationData
                s.readDataField(data,DATA)
                result.data = data
            else: break

proc readSpell(s): SpellRecord =
    result = SpellRecord(kind: SPEL)
    preamble($SPEL)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of SPDT:
                var data: SpellData
                s.readDataField(data,SPDT)
                result.data = data
            of ENAM:
                var data: Enchantment
                s.readDataField(data,ENAM)
                result.enchantments.add(data)
            else: break

proc readStartScript(s): StartScriptRecord =
    result = StartScriptRecord(kind: SSCR)
    preamble($SSCR)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of DATA:
                result.data = s.readStrField(DATA)
            of NAME:
                result.full_name = s.readStrField(NAME).some
            else: break

proc readStatic(s): StaticRecord =
    result = StaticRecord(kind: STAT)
    preamble($STAT)

    var tag:string
    while true:
        tag = s.peekTag()

        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            else: break


proc readMaster(s:Stream): MasterFile =
    let mast = s.readStrField(MAST)
    checkTag(s.readTag(),DATA)
    s.skip(SZ32)
    let data = s.readUint64()
    return MasterFile(mast: mast,data: data)
    

proc readHeader*(s:Stream): TES3HeaderRecord =
    result = TES3HeaderRecord(kind: TES3)
    result.header = HeaderData()
    preamble($TES3)

    var tag:string
    while true:
        tag = s.peekStr(TAGSIZE)
        case tag:
            of HEDR:
                checkTag(s.readTag(),HEDR)
                s.skip(SZ32)
                result.header.version = s.readFloat32()
                result.header.flags = s.readUint32()
                result.header.author = stripEverything(s.readStr(int(AUTHOR_SIZE)))
                result.header.fileDesc = stripEverything(s.readStr(int(DESC_SIZE)))
                result.header.numRecords = s.readUint32()
            of MAST:
                result.masters.add(s.readMaster())
            else: break

proc readWeapon(s): WeaponRecord =
    result = WeaponRecord(kind: WEAP)
    preamble($WEAP)

    var tag:string
    while true:
        tag = s.peekTag()
        case tag:
            of NAME:
                result.id = s.readStrField(NAME)
            of MODL:
                result.model_name = s.readStrField(MODL).some
            of FNAM:
                result.full_name = s.readStrField(FNAM).some
            of WPDT:
                var data: WeaponData
                s.readDataField(data,WPDT)
                result.data = data
            of ITEX:
                result.icon_name = s.readStrField(ITEX).some
            of ENAM:
                result.enchantment_id = s.readStrField(ENAM).some
            of SCRI:
                result.script_name = s.readStrField(SCRI).some
            else: break


proc skipTag(s) =
    discard s.readStr(TAGSIZE)
    let size = s.readUint32()
    s.skip(size.int + 8)


proc readPlugin*(fileName:string): TES3File = 
    result = TES3File()
    var s = newFileStream(fileName)

    var tag:string

    while not s.atEnd():
        tag = s.peekStr(TAGSIZE)
        echo tag
        case tag:
            of $ACTI: result.activators.add(s.readActivator())
            of $ALCH: result.potions.add(s.readAlchemy())
            of $APPA: result.alchemy_apparatus.add(s.readApparatus())
            of $ARMO: result.armor.add(s.readArmor())
            of $BODY: result.body_parts.add(s.readBody())
            of $BOOK: result.books.add(s.readBook())
            of $BSGN: result.birthsigns.add(s.readBirthsign())
            of $CELL: result.cells.add(s.readCell())
            of $CLAS: result.classes.add(s.readClass())
            of $CLOT: result.clothing.add(s.readClothing())
            of $CONT: result.containers.add(s.readContainer())
            of $CREA: result.creatures.add(s.readCreature())
            of $DIAL: result.dialogue.add(s.readDialogue())
            of $DOOR: result.doors.add(s.readDoor())
            of $ENCH: result.enchantments.add(s.readEnchantment())
            of $FACT: result.factions.add(s.readFaction())
            of $GLOB: result.globals.add(s.readGlobal())
            of $GMST: result.game_settings.add(s.readGMST())
            of $INFO: result.dialogue_topics.add(s.readInfo())
            of $INGR: result.ingredients.add(s.readIngredient())
            of $LAND: result.landscapes.add(s.readLand())
            of $LEVC: result.leveled_creatures.add(s.readLeveledCreature())
            of $LEVI: result.leveled_items.add(s.readLeveledItem())
            of $LIGH: result.lights.add(s.readLight())
            of $LOCK: result.locks.add(s.readLock())
            of $LTEX: result.land_textures.add(s.readLandTexture())
            of $MGEF: result.magic_effects.add(s.readMagicEffect())
            of $MISC: result.miscellaneous.add(s.readMisc())
            of $NPC: result.npcs.add(s.readNPC())
            of $PGRD: result.pathgrids.add(s.readPathGrid())
            of $PROB: result.probes.add(s.readProbe())
            of $RACE: result.races.add(s.readRace())
            of $REGN: result.regions.add(s.readRegion())
            of $REPA: result.repair_items.add(s.readRepairTool())
            of $SCPT: result.scripts.add(s.readScript())
            of $SKIL: result.skills.add(s.readSkill())
            of $SNDG: result.sound_generators.add(s.readSoundGenerator())
            of $SOUN: result.sounds.add(s.readSound())
            of $SPEL: result.spells.add(s.readSpell())
            of $SSCR: result.start_scripts.add(s.readStartScript())
            of $STAT: result.statics.add(s.readStatic())
            of $TES3: result.header = s.readHeader()
            of $WEAP: result.weapons.add(s.readWeapon())
            else: break
    s.close()




