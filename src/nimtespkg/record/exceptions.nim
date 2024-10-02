
type
    EnumConversionError = ref object of CatchableError


proc newEnumConversionError*(message:string): EnumConversionError = EnumConversionError(msg:message)