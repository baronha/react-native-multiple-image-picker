import React from 'react'
import { View } from './View'
import { Row, RowProps } from './Row'
import { StyleSheet, TouchableOpacity } from 'react-native'
import { Text } from './Text'
import useTheme from '../hook/useTheme'

interface CounterViewProps extends RowProps {
  value?: number
  onChange: (value: number) => void
}

export function CounterView({
  value = 0,
  onChange,
  ...props
}: CounterViewProps) {
  const { background_2 } = useTheme()

  return (
    <Row gap={8} {...props}>
      <TouchableOpacity
        activeOpacity={0.9}
        style={[style.button, { backgroundColor: background_2 }]}
        onPress={() => onChange(value - 1 < 0 ? 0 : value - 1)}
      >
        <Text style={style.buttonText}>－</Text>
      </TouchableOpacity>
      <View style={style.counterView}>
        <Text style={style.buttonText}>{value}</Text>
      </View>
      <TouchableOpacity
        activeOpacity={0.9}
        style={[style.button, { backgroundColor: background_2 }]}
        onPress={() => onChange(value + 1)}
      >
        <Text style={style.buttonText}>+</Text>
      </TouchableOpacity>
    </Row>
  )
}

const style = StyleSheet.create({
  counterView: {
    //
    height: 32,
    paddingHorizontal: 12,
    borderRadius: 4,
    alignItems: 'center',
    justifyContent: 'center',
  },
  button: {
    borderRadius: 4,
    height: 32,
    width: 32,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    fontSize: 16,
    fontWeight: 'bold',
    fontFamily: 'Avenir',
  },
})
