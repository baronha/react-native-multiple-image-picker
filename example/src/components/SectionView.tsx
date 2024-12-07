import React from 'react'
import { Row } from './Row'
import { CodeTag } from './CodeTag'
import { View } from './View'
import { Text } from './Text'
import { StyleSheet, Switch } from 'react-native'
import { useAppContext } from '../hook/context'
import { Config } from '@baronha/react-native-multiple-image-picker'
import { SegmentControl } from './SegmentControl'

type key = keyof Config
interface SectionViewProps {
  title: key
  description: string
  optionKey?: key
  children?: React.ReactNode
  defaultValue?: boolean
  segmentControl?: string[]
}

export default function SectionView({
  title,
  description,
  optionKey,
  children,
  defaultValue = false,
  segmentControl,
}: SectionViewProps) {
  const { options, setOptions } = useAppContext()

  return (
    <View style={style.section}>
      <Row style={style.section}>
        <View flex={1} style={style.sectionTitle}>
          <CodeTag>{title}</CodeTag>
          <Text style={style.des}>{description}</Text>
        </View>
        {children ||
          (optionKey ? (
            !segmentControl ? (
              <Switch
                value={(options?.[optionKey] as any) ?? defaultValue}
                onValueChange={(valueChange) =>
                  setOptions(optionKey, valueChange)
                }
              />
            ) : null
          ) : null)}
      </Row>

      {segmentControl && optionKey ? (
        <SegmentControl
          selectedIndex={
            segmentControl.indexOf(
              (options?.[optionKey] as any) ?? defaultValue ?? ''
            ) ?? 0
          }
          values={segmentControl}
          onValueChange={(valueChange) => setOptions(optionKey, valueChange)}
        />
      ) : null}
    </View>
  )
}

const style = StyleSheet.create({
  section: {
    rowGap: 12,
    columnGap: 24,
  },
  sectionTitle: {
    gap: 8,
  },

  des: {
    fontSize: 12,
    // marginBottom: 12,
  },
})
