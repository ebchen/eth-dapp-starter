import {
  Button,
  Card,
  createStyles,
  Flex,
  Image,
  NumberInput,
  Text,
  Title,
} from "@mantine/core";
import { useEffect, useState } from "react";

const useStyles = createStyles((theme) => ({
  padding: {
    padding: 50,
  },
  image: {
    borderRadius: theme.radius.md,
  },
  card: {
    maxWidth: "fit-content",
  },
}));
export default function TokenCard({
  token,
  startAuction,
  submitBid,
  endAuction,
  withdraw,
  address,
}) {
  const { classes } = useStyles(undefined, undefined);

  const [bid, setBid] = useState(0);

  useEffect(() => {
    if (token) {
      setBid(token.price);
    }
  }, [token]);

  if (token === null) {
    return <></>;
  }

  return (
    <Card shadow="md" radius="lg" className={classes.card}>
      <Flex gap="xl" justify="center">
        <Image
          className={classes.image}
          src={`https://ipfs.io/ipfs/${token.metadata.image.split("//")[1]}`}
          width={400}
          height={400}
          fit="contain"
        />
        <Flex direction="column" justify="space-between">
          <Flex direction="column">
            <Title order={2}>Token #{token.id}</Title>
            <Text size="xl">
              {token.status === "Not Started"
                ? "Minimum Bid"
                : token.status === "Ongoing"
                ? "Highest Bid"
                : "Final Bid"}
              : {token.price} PennCoin
            </Text>
            {token.status === "Ended" && (
              <Text size="xl">Sold to: {token.highestBidder}</Text>
            )}
          </Flex>
          {token.status === "Not Started" ? (
            token.owner === address ? (
              <Button size="xl" onClick={startAuction}>
                Start Auction
              </Button>
            ) : (
              ""
            )
          ) : token.status === "Ongoing" ? (
            <Flex direction="column" gap="sm">
              <NumberInput
                placeholder="Your bid"
                size="xl"
                min={token.price}
                step={0.0005}
                precision={4}
                value={bid}
                onChange={(value) => setBid(value)}
              />
              <Button size="xl" onClick={() => submitBid(bid)}>
                Submit bid
              </Button>
              {token.owner === address ? (
                <Button size="xl" onClick={endAuction}>
                  End Auction
                </Button>
              ) : (
                ""
              )}
            </Flex>
          ) : (
            <Button size="xl" onClick={withdraw}>
              Withdraw Bid
            </Button>
          )}
        </Flex>
      </Flex>
    </Card>
  );
}
